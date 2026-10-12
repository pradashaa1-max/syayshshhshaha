# StandRise Rework — REAL OFFSETS
Bundle: com.SKITLSE.StandRise
Dump: 2026-10-11 | UnityFramework + metadata v31

## PlayerController
0x20  Transform*          mainCameraHolder
0x28  GameObject*         fpsCameraHolder
0x30  BipedMap*           characterBiped
0x59  Team                team
0x60  AimController*      aim
0x68  WeaponryController* weaponry
0x78  MovementController* movement
0x88  PlayerHitController* hit
0xC0  PlayerMainCamera*
0xC8  PlayerFPSCamera*

## AimController
0xA8  Vector3  headDirectiveAngles
0x110 Vector3  aim target
0x164 float
0x168 float
0x198 WeaponryController*

## WeaponController
0x3C  float
0x40  float (recoil)
