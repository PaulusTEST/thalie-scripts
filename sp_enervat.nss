//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDrain = d6();
    int nDuration = GetCasterLevel(OBJECT_SELF);
    nDuration = GetThalieCaster(OBJECT_SELF,oTarget,nDuration,FALSE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDrain = 4;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    effect eDrain = EffectNegativeLevel(nDrain);
    effect eLink = EffectLinkEffects(eDrain, eDur);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
        //Resist magic check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()+GetThalieSpellDCBonus(OBJECT_SELF), SAVING_THROW_TYPE_NEGATIVE))
            {
                //Apply the VFX impact and effects
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                effect eBad = GetFirstEffect(OBJECT_SELF);
                //Search for negative effects
                while(GetIsEffectValid(eBad))
                {
                    if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
                        GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
                        GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
                        GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
                        GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
                        {

                                RemoveEffect(OBJECT_SELF, eBad);
                        }
                    eBad = GetNextEffect(OBJECT_SELF);
                }
            }
        }
    }
}

