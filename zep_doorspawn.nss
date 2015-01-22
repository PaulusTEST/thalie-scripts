//::///////////////////////////////////////////////
//:: ZEP_DOORSPAWN.nss
//:: Copyright (c) 2001 Bioware Corp.
//:: Modified by Dan Heidel 1/14/04 for CEP
//:://////////////////////////////////////////////
/*
    Place in the OnHeartbeat function of a placeable door
    to ensure proper functioning.  See zep_openclose for
    further documentation.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  January 2002
//:://////////////////////////////////////////////

#include "nwnx_funcsext"

void main()
{
    // Run only once
    SetScript(OBJECT_SELF, DOOR_SCRIPT_HEARTBEAT, "noscript");
    
    int nIsOpen = GetIsOpen(OBJECT_SELF);
    if(nIsOpen == 1)return; //if door is open, quit
    if(GetLocalObject(OBJECT_SELF, "DOORWAY_BREAK") != OBJECT_INVALID) return; //if gateblock is already in place, quit
    string sGateBlock = GetLocalString(OBJECT_SELF, "DOORWAY_BREAK");
    if(GetStringLength(sGateBlock) == 0)
      return;
    location lSelfLoc = GetLocation(OBJECT_SELF);
    object oSelf = OBJECT_SELF;
    PlayAnimation(ANIMATION_PLACEABLE_CLOSE);
//    SpeakString("Creating doors break "+sGateBlock);
    SetLocalObject(oSelf, "DOORWAY_BREAK", CreateObject(OBJECT_TYPE_PLACEABLE, sGateBlock, lSelfLoc));
}
