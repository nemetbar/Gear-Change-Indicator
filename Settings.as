[Setting category="Settings" name="Plugin Enabled"]
bool S_PluginEnabled = true;

[Setting category="Settings" name="Show/Hide With Game UI"]
bool S_HideWithGame = false;

[Setting category="Settings" name="Indicator Position X" min=0 max=1]
float S_PositionX = 0.5;

[Setting category="Settings" name="Indicator Position Y" min=0 max=1]
float S_PositionY = 0.9;

[Setting category="Settings" name="Size"]
int S_Size = 50;

[Setting category="Settings" name="Color" color]
vec4 S_Color = vec4(1, 1, 1, 1); // white

[Setting category="Settings" name="Animation Length" min=0.1 max=2.0]
float S_AnimationLength = 0.3; // seconds