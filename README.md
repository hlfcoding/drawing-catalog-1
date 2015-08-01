# Drawing Catalog #1

CoffeeScript sketches and boilerplate using Processing via
[fjenett/coffeescript-mode-processing](http://github.com/fjenett/coffeescript-mode-processing).

## I. Elementary

### Attraction

Animation of 137d8a0, but with many nodes, line view-mode with collisions, repulsions, and evasions:

![animation](https://cloud.githubusercontent.com/assets/100884/8978570/23d28906-3658-11e5-9cdb-fa70d90efe6f.gif)

Screenshot of f5a8a78, but with many nodes, line view-mode with collisions, repulsions, and initial gravity:

![image](https://cloud.githubusercontent.com/assets/100884/8796279/63549bd0-2f48-11e5-843c-30b6b55d3464.png)

Screenshot of f5a8a78, but with many nodes, line view-mode with collisions and repulsions:

![image](https://cloud.githubusercontent.com/assets/100884/8773653/b28b6f94-2e8a-11e5-9c07-8af75f4e391a.png)

Screenshot of b0f777c, but with many nodes, line view-mode with collisions:

![image](https://cloud.githubusercontent.com/assets/100884/8760865/fae85cb0-2ce7-11e5-9cd6-b046690304b0.png)

Screenshot of deacedc, but with few nodes, line view-mode in toroidal container:

![image](https://cloud.githubusercontent.com/assets/100884/8743263/127cd304-2c22-11e5-9a8e-e088ac974123.png)

## Building [![devDependency Status](https://img.shields.io/david/dev/hlfcoding/drawing-catalog-1.svg)](https://david-dm.org/hlfcoding/drawing-catalog-1#info=devDependencies)

```bash
hlf-jquery> npm install
hlf-jquery> grunt install

# to run (open and build in Processing)
hlf-jquery> grunt lib

# to read some docs
hlf-jquery> grunt docs
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
        "docs",
        "gh-pages",
        "lib",
        "node_modules",
        "web-export-coffee"
      ]
    }
  ]
}
```
