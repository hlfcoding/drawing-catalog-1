# Drawing Catalog #1

CoffeeScript sketches and boilerplate using Processing via
[fjenett/coffeescript-mode-processing](http://github.com/fjenett/coffeescript-mode-processing).

## I. Elementary

### Attraction

Screenshot of f5a8a78, but with many nodes, line view-mode with collisions and repulsions:

![image](https://cloud.githubusercontent.com/assets/100884/8773653/b28b6f94-2e8a-11e5-9c07-8af75f4e391a.png)

Screenshot of b0f777c, but with many nodes, line view-mode with collisions:

![image](https://cloud.githubusercontent.com/assets/100884/8760865/fae85cb0-2ce7-11e5-9cd6-b046690304b0.png)

Screenshot of deacedc, but with few nodes, line view-mode in toroidal container:

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
