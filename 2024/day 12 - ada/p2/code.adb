with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Containers.Hashed_Sets;
with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Vectors;

procedure Code is
    use Ada.Text_IO;
    use Ada.Integer_Text_IO;
    use Ada.Containers;

    type Coord is record
        x: Integer;
        y: Integer;
    end record;

    function "="(Left, Right : Coord) return Boolean is
    begin
        return Left.x = Right.x and then Left.y = Right.y;
    end "=";

    function Equivalent_Elements(Left, Right : Coord) return Boolean is
    begin
        return Left = Right;
    end Equivalent_Elements;

    function Hasher(Key : Coord) return Hash_Type is
    begin
        return Hash_Type(Key.x) * 23 + Hash_Type(Key.y);
    end Hasher;
    
    package Area_Coords is new Ada.Containers.Hashed_Sets (
        Element_Type        => Coord,
        Hash                => Hasher,
        -- Equal               => "=",
        Equivalent_Elements => Equivalent_Elements
    );
    use Area_Coords;

    package Coord_Vector is new Ada.Containers.Vectors (
        Index_Type   => Positive,
        Element_Type => Coord
    );
    use Coord_Vector;

    package Str_Vector is new Ada.Containers.Indefinite_Vectors (
        Index_Type   => Positive,
        Element_Type => String
    );
    use Str_Vector;
    
    File   : File_Type;
    Line   : String(1..141);
    Length : Integer;
    Lines  : Str_Vector.Vector;

    function Check_Area(Start : Coord) return Integer is
        Coords    : Coord_Vector.Vector;
        Cur       : Coord;
        Idx       : Integer;
        Match     : Character;

        Set       : Area_Coords.Set;
        Area      : Integer;
        Corners   : Integer;
        A         : array(1..4) of Boolean;
        D         : array(1..4) of Boolean;
    begin
        Idx         := 1;
        Match       := Lines(Start.y)(Start.x);

        if Match = '.' then return 0; end if;

        Coords.Append(Start);
        while Count_Type(Idx) <= Coords.Length loop
            Cur := Coords(Idx);

            if Cur.x <= Length and Cur.y <= Length and Cur.x >= 1 and Cur.y >= 1 then
                if Lines(Cur.y)(Cur.x) = Match then
                    Coords.Append((Cur.x, Cur.y+1));
                    Coords.Append((Cur.x, Cur.y-1));
                    Coords.Append((Cur.x+1, Cur.y));
                    Coords.Append((Cur.x-1, Cur.y));
                    
                    Lines(Cur.y)(Cur.x) := '.';
                    Idx := Idx + 1;
                else
                    Coords.Delete(Index => Idx);
                end if;
            else
                Coords.Delete(Index => Idx);
            end if;
        end loop;

        for Coord of Coords loop
            Set.Insert(Coord);
        end loop;

        Area      := Integer(Coords.Length);
        Corners   := 0;

        for Coord of Set loop
            A := (
                Set.Contains((Coord.x+1, Coord.y)),
                Set.Contains((Coord.x, Coord.y+1)),
                Set.Contains((Coord.x-1, Coord.y)),
                Set.Contains((Coord.x, Coord.y-1))
            );
            D := (
                Set.Contains((Coord.x+1, Coord.y-1)),
                Set.Contains((Coord.x+1, Coord.y+1)),
                Set.Contains((Coord.x-1, Coord.y+1)),
                Set.Contains((Coord.x-1, Coord.y-1))
            );
            if (not A(4) and not A(1)) or (A(4) and A(1) and not D(1)) then
                Corners := Corners + 1;
            end if;
            if (not A(1) and not A(2)) or (A(1) and A(2) and not D(2)) then
                Corners := Corners + 1;
            end if;
            if (not A(2) and not A(3)) or (A(2) and A(3) and not D(3)) then
                Corners := Corners + 1;
            end if;
            if (not A(3) and not A(4)) or (A(3) and A(4) and not D(4)) then
                Corners := Corners + 1;
            end if;
        end loop;

        return Area * Corners;

    end Check_Area;

    Sum : Integer;

begin
    Sum := 0;

    Open(File, In_File, "../input.txt");

    while not End_Of_File(File) loop
        Get_Line(File, Line, Length);
        Lines.Append(Line);
    end loop;

    Close (File);

    for y in 1 .. Natural(Length) loop
        for x in 1 .. Natural(Length) loop
            Sum := Sum + Check_Area((x, y));
        end loop; 
    end loop;

    Put_Line(Sum'Image);
end Code;
