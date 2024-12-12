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
        Perimeter : Integer;
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
        Perimeter := 4 * Area;

        for Coord of Set loop
            if Set.Contains((Coord.x+1, Coord.y)) then Perimeter := Perimeter-2; end if;
            if Set.Contains((Coord.x, Coord.y+1)) then Perimeter := Perimeter-2; end if;
        end loop;

        return Area * Perimeter;

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
            -- Put_Line("(" & x'Image & ", " & y'Image & ") -> " & Lines(y-1)(x));
            Sum := Sum + Check_Area((x, y));
        end loop; 
    end loop;

    Put_Line(Sum'Image);
end Code;
