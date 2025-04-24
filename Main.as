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
    if (UI::MenuItem("\\$1BA" + Icons::Kenney::Cog + "\\$G Gear-Change-Indicator", "", S_PluginEnabled))
        S_PluginEnabled = !S_PluginEnabled;
}

void Render(){
    if (!S_PluginEnabled) return;
    if (S_HideWithGame && !UI::IsGameUIVisible()) return;

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = S_Position * screenSize;

    if (animationTimer < S_AnimationLength * 1000){
        nvg::BeginPath();
        nvg::TextAlign(nvg::Align::Center);
        nvg::GlobalAlpha(1 - animationTimer / (S_AnimationLength * 1000));
        nvg::FontSize(S_FontSize);
        nvg::FillColor(S_FontColor);
        nvg::Text(relativePos, "" + curGear);
        nvg::ClosePath();
    }
    
}

void Update(uint deltaTime){
    if (!S_PluginEnabled) return;

    auto player = VehicleState::ViewingPlayerState();
    if (player is null) return;


    // check for gear change
    curGear = player.CurGear;
    if (prevGear != curGear){
        prevGear = curGear;

        animationTimer = 0;
    }

    if (animationTimer < S_AnimationLength * 1000){
        animationTimer += deltaTime;
    }

}
