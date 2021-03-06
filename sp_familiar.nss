//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////
#include "me_soul_inc"
#include "mys_assoc_lib"

void ApplyFamiliarBonuses(object oPC)
{
    object oSummon = GetAssociate(ASSOCIATE_TYPE_FAMILIAR);
    int iLevel = GetLevelByClass(CLASS_TYPE_SORCERER,oPC)+GetLevelByClass(CLASS_TYPE_WIZARD,oPC);
    int iAC = (iLevel+1)/2;
    int iEnch = (iLevel/6);  //IP
    int iRegen = (iLevel /3);
    int iAB =  (iLevel /5)*2;
    int iSave = (iLevel/5);
    effect eAC = EffectACIncrease(iAC,AC_ARMOUR_ENCHANTMENT_BONUS);
    //effect eEnch = EffectACIncrease(iAC,AC_ARMOUR_ENCHANTMENT_BONUS);
    effect eRegen = EffectRegenerate(iRegen,6.0);
    effect eAB = EffectAttackIncrease(iAB);
    effect eSave = EffectSavingThrowIncrease(iSave,SAVING_THROW_ALL);
    effect eDamageReduction;
    if (iLevel <= 5)
    {
        eDamageReduction = EffectDamageReduction(5,DAMAGE_POWER_PLUS_ONE);
    }
    else if (iLevel <= 10)
    {
        eDamageReduction = EffectDamageReduction(5,DAMAGE_POWER_PLUS_TWO);
    }
    else if (iLevel <= 15)
    {
        eDamageReduction = EffectDamageReduction(5,DAMAGE_POWER_PLUS_THREE);
    }
    else if (iLevel <= 20)
    {
        eDamageReduction = EffectDamageReduction(10,DAMAGE_POWER_PLUS_FOUR);
    }
    else if (iLevel <= 25)
    {
        eDamageReduction = EffectDamageReduction(10,DAMAGE_POWER_PLUS_FIVE);
    }
    else if (iLevel <= 30)
    {
        eDamageReduction = EffectDamageReduction(10,DAMAGE_POWER_PLUS_SIX);
    }
    else if (iLevel <= 35)
    {
        eDamageReduction = EffectDamageReduction(15,DAMAGE_POWER_PLUS_SEVEN);
    }
    else
    {
        eDamageReduction = EffectDamageReduction(20,DAMAGE_POWER_PLUS_EIGHT);
    }
    eAC = SupernaturalEffect(eAC);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAC,oSummon);
    eRegen = SupernaturalEffect(eRegen);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eRegen,oSummon);
    eAB = SupernaturalEffect(eAB);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAB,oSummon);
    eSave = SupernaturalEffect(eSave);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSave,oSummon);
    eDamageReduction = SupernaturalEffect(eDamageReduction);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDamageReduction,oSummon);
    itemproperty ip = ItemPropertyEnhancementBonus(iEnch);
    object oCW1 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oSummon);
    object oCW2 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oSummon);
    object oCW3 = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oSummon);
    object oCW4 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oSummon);
    object oCW5 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oSummon);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oCW1);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oCW2);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oCW3);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oCW4);
    AddItemProperty(DURATION_TYPE_PERMANENT,ip,oCW5);

}


void main()
{
    //Yep thats it
    SummonFamiliar();

    // for /f chat command
    SetLocalObject(OBJECT_SELF, "FAMILIAR", GetAssociate(ASSOCIATE_TYPE_FAMILIAR));

//    DelayCommand(3.0,ApplyFamiliarBonuses(OBJECT_SELF));

    //zistim potrebne udaje , OBJECT_SELF je ten co volal script cize HRAC
    object oBeast     = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
    object oSoulStone = GetSoulStone(OBJECT_SELF);
    int    nHP        = GetLocalInt(oSoulStone, "hp_fam");
    if(nHP >= GetCurrentHitPoints(oBeast))
      nHP = GetCurrentHitPoints(oBeast) - 2;

    // Set custom properties
    int iAssociateType = ASSOCIATE_TYPE_FAMILIAR;
    object oAssociate = GetAssociate(iAssociateType, OBJECT_SELF);
    object oSoul = GetSoulStone(OBJECT_SELF);
    int iAppearance = GetAssociateAppearanceType(oSoul, oAssociate, iAssociateType);
    int iSoundset = GetAssociateSoundset(oSoul, oAssociate, iAssociateType);
    string sPortrait = GetAssociatePortraitResRef(oSoul, oAssociate, iAssociateType);
    string sName = GetAssociateName(oSoul, oAssociate, iAssociateType);

    if (sName != "")
        SetName(oAssociate, sName);

    if (iAppearance)
        SetCreatureAppearanceType(oAssociate, iAppearance);

    if (sPortrait != "")
        SetPortraitResRef(oAssociate, sPortrait);

    if (iSoundset)
        SetSoundset(oAssociate, iSoundset);

    //aplikujem dmg na animal companiona
    //je tu jeden future bug, ak zmenim animal companiona pocas lvl mal by sa HP
    //rozdiel na dusi bytosti zmazat
/*    effect eDmg = EffectDamage(nHP, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_NORMAL);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oBeast);
    SetLocalObject(OBJECT_SELF,"FAMILIAR",oBeast);*/
}
