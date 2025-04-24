uint prevGear = -1;
uint curGear = -1;

uint animationTimer = 0;

void Main(){
    uint endTime = Time::get_Now();
    uint deltaTime = 0;

    while (true){
        deltaTime = Time::get_Now() - endTime;
        endTime = Time::get_Now();

        Update(deltaTime);
        yield();
    }
}

void RenderMenu(){
    if (UI::MenuItem("\\$1BA" + Icons::Kenney::Cog + "\\$G Gear-Change-Indicator", "", Setting_PluginEnabled))
        Setting_PluginEnabled = !Setting_PluginEnabled;
}

void Render(){
    if (!Setting_PluginEnabled) return;
    if (Setting_HideWithGame && !UI::IsGameUIVisible()) return;

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = Setting_Position * screenSize;

    if (animationTimer < Setting_AnimationLength * 1000){
        nvg::BeginPath();
        nvg::TextAlign(2); // center
        if (animationTimer < (Setting_AnimationLength * 1000) / 2)
            nvg::GlobalAlpha(1);
        else
            nvg::GlobalAlpha((1 - animationTimer / (Setting_AnimationLength * 1000)) * 2);
        nvg::FontSize(Setting_FontSize);
        nvg::Text(relativePos, "" + curGear);
        nvg::ClosePath();
    }
    
}

void Update(uint deltaTime){
    if (!Setting_PluginEnabled) return;

    auto player = VehicleState::ViewingPlayerState();
    if (player is null) return;


    // check for gear change
    curGear = player.CurGear;
    if (prevGear != curGear){
        prevGear = curGear;

        animationTimer = 0;
    }

    if (animationTimer < Setting_AnimationLength * 1000){
        animationTimer += deltaTime;
    }

}
