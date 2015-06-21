# Drawing Catalog #1

CoffeeScript sketches and boilerplate using Processing via
[fjenett/coffeescript-mode-processing](http://github.com/fjenett/coffeescript-mode-processing).

## I. Elementary

Screenshot of HEAD, but with line view-mode in toroidal container:

![Elemental](https://s3.amazonaws.com/f.cl.ly/items/2A1X0R3B0w0Y3q1P1J2V/Screen%20Shot%202012-10-22%20at%202.12.30%20AM.png)

## Building

Very simple for now:

```bash
$ bower install
$ source ./<sketch>/build.sh
```

## Sample ST2 Project File

```json
{
  "folders":
  [
    {
      "path": "processing-coffee-sketches",
      "file_exclude_patterns": [
        "template-coffee/*.js"
      ],
      "folder_exclude_patterns": [
        "bower_components",
        "node_modules",
        "web-export-coffee"
      ]
    }
  ]
}
```
