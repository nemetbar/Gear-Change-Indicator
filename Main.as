uint prevGear = -1;
uint curGear = -1;
bool upShift = true;

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
    if (VehicleState::ViewingPlayerState() is null) return;

    vec2 screenSize = vec2(Draw::GetWidth(), Draw::GetHeight());
    vec2 relativePos = vec2(S_PositionX, S_PositionY) * screenSize;

    vec2 arrowSize = vec2(S_Size / 2 - S_Size / 4, S_Size / 2);
    float animationLength = S_Size / 2.5 + S_Size / 2.7;
    float animationProgress = animationTimer / (S_AnimationLength * 1000);
    vec2 arrowPos;

    if (animationTimer < S_AnimationLength * 1000){
        nvg::TextAlign(nvg::Align::Center);
        nvg::GlobalAlpha(1 - animationProgress);
        nvg::FontFace(5);
        nvg::FontSize(S_Size);
        nvg::FillColor(S_Color);
        nvg::Text(relativePos, "" + curGear);

        if (!S_ShowArrow) return;
        nvg::BeginPath();
        if (upShift)
            arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) + vec2(0, S_Size / 2.5) - vec2(0, animationProgress * animationLength);
        else
            arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) - vec2(0, S_Size / 2.7) + vec2(0, animationProgress * animationLength);
        nvg::MoveTo(arrowPos + vec2(-arrowSize.x / 2, 0)); // Left point
        nvg::LineTo(arrowPos + vec2(arrowSize.x / 2, 0));  // Right point
        if (upShift)
            nvg::LineTo(arrowPos + vec2(0, -arrowSize.y));
        else
            nvg::LineTo(arrowPos + vec2(0, arrowSize.y));
        nvg::ClosePath();

        nvg::Fill();
    }
}

void Update(uint deltaTime){
    if (!S_PluginEnabled) return;

    auto player = VehicleState::ViewingPlayerState();
    if (player is null) return;


    // check for gear change
    curGear = player.CurGear;
    if (prevGear != curGear){
        if (prevGear > curGear)
            upShift = false;
        else
            upShift = true;

        prevGear = curGear;

        animationTimer = 0;
    }

    if (animationTimer < S_AnimationLength * 1000){
        animationTimer += deltaTime;
    }

}
