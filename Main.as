uint prevGear = 1;
uint curGear = 1;
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

    float animationLength = S_Size * 0.6;
    float animationProgress = animationTimer / (S_AnimationLength * 1000);

    if (S_HelpPositionChange){
        RenderBackground(relativePos, 0);
        RenderText(relativePos, 0);
        RenderArrow(relativePos, 0, animationLength);

        return;
    }

    if (animationTimer < S_AnimationLength * 1000){
        RenderBackground(relativePos, animationProgress);
        RenderText(relativePos, animationProgress);
        RenderArrow(relativePos, animationProgress, animationLength);
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

void RenderText(vec2 relativePos, float animationProgress){
    if (S_ShowShadow){
        nvg::TextAlign(nvg::Align::Center);
        nvg::GlobalAlpha(1 - animationProgress);
        nvg::FontFace(nvg::LoadFont("Fonts/Oswald-Regular.ttf"));
        nvg::FontSize(S_Size);
        nvg::FillColor(S_ShadowColor);
        if (curGear == 0)
            nvg::Text(relativePos + vec2(S_Size / 20, S_Size / 20), "R");
        else
            nvg::Text(relativePos + vec2(S_Size / 20, S_Size / 20), "" + curGear);
    }

    nvg::TextAlign(nvg::Align::Center);
    nvg::GlobalAlpha(1 - animationProgress);
    nvg::FontFace(nvg::LoadFont("Fonts/Oswald-Regular.ttf"));
    nvg::FontSize(S_Size);
    nvg::FillColor(S_Color);
    if (curGear == 0)
        nvg::Text(relativePos, "R");
    else
        nvg::Text(relativePos, "" + curGear);
}


void RenderArrow(vec2 relativePos, float animationProgress, float animationLength){
    if (!S_ShowArrow) return;

    vec2 arrowSize = vec2(S_Size / 2 - S_Size / 4, S_Size / 2);
    vec2 arrowPos;

    if (S_ShowShadow){
        nvg::FillColor(S_ShadowColor);
        nvg::GlobalAlpha(1 - animationProgress);
        nvg::BeginPath();
        if (upShift)
            arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) + vec2(0, S_Size / 2) - vec2(0, animationProgress * animationLength) + vec2(S_Size / 20, S_Size / 20);
        else
            arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) - vec2(0, S_Size / 2) + vec2(0, animationProgress * animationLength) + vec2(S_Size / 20, S_Size / 20);
        nvg::MoveTo(arrowPos + vec2(-arrowSize.x / 2, 0));
        nvg::LineTo(arrowPos + vec2(arrowSize.x / 2, 0));
        if (upShift)
            nvg::LineTo(arrowPos + vec2(0, -arrowSize.y));
        else
            nvg::LineTo(arrowPos + vec2(0, arrowSize.y));
        nvg::ClosePath();

        nvg::Fill();
    }

    nvg::FillColor(S_Color);
    nvg::GlobalAlpha(1 - animationProgress);
    nvg::BeginPath();
    if (upShift)
        arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) + vec2(0, S_Size / 2) - vec2(0, animationProgress * animationLength);
    else
        arrowPos = relativePos + vec2(S_Size / 2, -S_Size / 2.5) - vec2(0, S_Size / 2) + vec2(0, animationProgress * animationLength);
    nvg::MoveTo(arrowPos + vec2(-arrowSize.x / 2, 0)); // Left point
    nvg::LineTo(arrowPos + vec2(arrowSize.x / 2, 0));  // Right point
    if (upShift)
        nvg::LineTo(arrowPos + vec2(0, -arrowSize.y));
    else
        nvg::LineTo(arrowPos + vec2(0, arrowSize.y));
    nvg::ClosePath();

    nvg::Fill();
}

void RenderBackground(vec2 relativePos, float animationProgress){
    if (!S_ShowBackground) return;

    float widthDiff;
    if (S_ShowArrow)
        widthDiff = S_Size / 5;
    else
        widthDiff = - S_Size / 3.5;    

    nvg::FillColor(S_BackgroundColor);
    nvg::GlobalAlpha(1 - animationProgress);
    nvg::BeginPath();
    nvg::RoundedRect(
        relativePos.x - S_Size / 3,
        relativePos.y - S_Size,
        S_Size + widthDiff,
        S_Size + S_Size / 5,
        S_Size / 3
    );
    nvg::Fill();
}   