#pragma once
#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <mach-o/dyld.h>

#ifdef __cplusplus
extern "C" {
#endif
bool mem_read(uint64_t addr, void *buf, size_t size);
bool mem_write(uint64_t addr, const void *buf, size_t size);
uint64_t get_module_base(const char *name);
uint64_t get_il2cpp_base(void);
#ifdef __cplusplus
}
#endif

typedef struct { float x, y, z; } Vec3;

#define OFF_PC_MainCameraHolder     0x20
#define OFF_PC_FpsCameraHolder      0x28
#define OFF_PC_CharacterBiped       0x30
#define OFF_PC_ArmsBiped            0x38
#define OFF_PC_Team                 0x59
#define OFF_PC_AimController        0x60
#define OFF_PC_WeaponryController   0x68
#define OFF_PC_MecanimController    0x70
#define OFF_PC_MovementController   0x78
#define OFF_PC_ArmsAnimation        0x80
#define OFF_PC_HitController        0x88
#define OFF_PC_OcclusionController  0x90
#define OFF_PC_NetworkController    0x98
#define OFF_PC_PlayerMainCamera     0xC0
#define OFF_PC_PlayerFPSCamera      0xC8

#define OFF_AIM_HeadDirectiveAngles 0xA8
#define OFF_AIM_PlayerController    0xB8
#define OFF_AIM_MovementController  0xC0
#define OFF_AIM_Transform1          0xC8
#define OFF_AIM_Vector3_Target      0x110
#define OFF_AIM_Float1              0x164
#define OFF_AIM_Float2              0x168
#define OFF_AIM_Weaponry            0x198

#define OFF_WC_PlayerController     0x18
#define OFF_WC_Mecanim              0x20
#define OFF_WC_AnimController       0x28
#define OFF_WC_AnimParams           0x30
#define OFF_WC_Float1               0x3C
#define OFF_WC_Float2               0x40

#define OFF_HIT_LocalTime           0xC8
#define OFF_HIT_PhotonPlayer        0xB0
