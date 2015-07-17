# Drawing Catalog #1

CoffeeScript sketches and boilerplate using Processing via
[fjenett/coffeescript-mode-processing](http://github.com/fjenett/coffeescript-mode-processing).

## I. Elementary

Screenshot of HEAD, but with line view-mode in toroidal container:

![image](https://cloud.githubusercontent.com/assets/100884/8743263/127cd304-2c22-11e5-9a8e-e088ac974123.png)

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
