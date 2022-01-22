# Custom text graphic terminal menus and settings editor

### You'll thank me later

#
## Configure Settings
Add whatever settings you want to in the `SETTINGS` file.

```
$ SETTINGS
```
Settings must follow <`KEY`>="<`VALUE`>" format.
```bash
 1| TITLE="Super Awesome Thing"
 2| MAX_CONNECTIONS="4"
 3| ...
```
There are prebuilt `loadSettings()` and `saveSettings()` rountines inside the `ROUTINES.sh` file, as well as the following loop to update the `SETTINGS` file.
```bash
30| loadSettings
31| read -s
32| for key in "${!SETTINGS[@]}"
33| do
34|     SETTINGS_WIZARD=("SETTINGS WIZARD"
35|         "Enter new values below"
36|         "Press return key to accept current value" ""
37|         "${key}: ${SETTINGS[$key]}"
38|     )
39|     assignMenu SETTINGS_WIZARD
40|     SETTINGS[$key]="${SETTINGS[$key]}"
41|     while read -r REPLY
42|     do
43|         if (( ${#REPLY} > 0 ))
44|         then
45|             SETTINGS[$key]=$REPLY
46|         fi
47|         break
48|     done
49| done
50| saveSettings
```
* `(Note)` This is a good example of how menus can be built dynamically and interact with the user or other software.
#
## Adding Menus
Menus are found in the `ROUTINES.sh` file. The first element in a menu array is the `TITLE` that will display atop the menu.

```
$ ROUTINES.sh
```
```bash
33| # ---------- Menus ---------- #
34| THING=("THING TITLE" "First line" "" "[T]his menu")
```
When you call `assignMenu` on `THING`, the menu will load like so calling:
```
65| assignMenu THING
```
outputs:
```
*-----------------------| THING TITLE |----------------------*
|                                                            |
|        First line                                          |
|                                                            |
|        [T]his menu                                         |
|                                                            |
*------------------------------------------------------------*
```
#
## Running
Set the permissions for your shell script
```
$ chmod +x SETTINGS_EDITOR.sh
```
Then run it
```
$ ./SETTINGS_EDITOR.sh
```
