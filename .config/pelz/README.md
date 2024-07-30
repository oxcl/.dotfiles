Pelz is a themeing framework inspired by base16. which allows you to automatically create new themes for all sorts of applications by defining a color scheme only once

Pelz supports around 40 colors but only 10 are required.
so you can create a functioning theme by providing only the main 10 colors:
`fg`,`bg`,`black`,`red`,`green`,`yellow`,`blue`,`magenta`,`cyan`,`white`

for the colors that are not provided one of the main 10 colors is picked as a fallback

* USAGE:
to add a new theme you can write a toml file in the format of `sample_theme.toml` file.
and for ease of use you can add it to the themes directory in `$XDG_CONFIG_HOME/pelz/themes`

to add support for a new program you need to create a template file. a template file is the configuration file for that
program but the color values should be replaced with pelz place holders. 
so if you want to add the color green somewhere in the configuration you should add `{{green}}` which will later be replaced 
by pelz with the color green in the specified theme.

to create a configuration file for a supported program based on a theme use the pelz command like this:
```
pelz name_of_template name_of_theme] > configuration_file_path
```
or
```
cat theme_file.toml | pelz name_of_template > configuration_file_path
```
