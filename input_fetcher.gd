extends RefCounted

var input:String # thank you spaghetti monster

func get_input(tree:SceneTree) -> String:

    var regex := RegEx.new()
    regex.compile("res://(?<year>\\d+)/(?<day>\\d+)p\\d+\\.gd")
    var res := regex.search(tree.get_script().resource_path)
    var year := res.get_string("year").to_int()
    var day := res.get_string("day").to_int()

    var dir := DirAccess.open("res://")
    var filename := ".cache/y%dd%d" % [year, day]
    if dir.dir_exists(".cache"):
        if dir.file_exists(filename):
            return FileAccess.get_file_as_string(filename)
        pass
    else:
        dir.make_dir(".cache")

    var url = "http://adventofcode.com/%d/day/%d/input" % [year, day]
    var hreq := HTTPRequest.new()
    tree.root.add_child(hreq)
    await hreq.ready
    hreq.request_completed.connect(func(_result, _response_code, _headers, body):
        input = body.get_string_from_utf8()
    )
    hreq.request(url, ["Cookie: session=" + OS.get_environment("AOC_COOKIE")])
    await hreq.request_completed

    hreq.queue_free()

    var file := FileAccess.open(filename, FileAccess.WRITE)
    file.store_string(input)
    file.close()

    return input