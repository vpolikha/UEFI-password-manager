#include "../include/main.h"

EFI_STATUS EFIAPI UefiMain(
    IN EFI_HANDLE ImageHandle,
    IN EFI_SYSTEM_TABLE *SystemTable){
    if (NULL == SystemTable){
        return EFI_INVALID_PARAMETER;
    }

    // SystemTable->ConOut->OutputString(SystemTable->ConOut, L"ZDAROVA KOROVA\r\n");
    // UINT32 revision = SystemTable->Hdr.Revision;
    // UINT32 major = revison >> 16;
    // UINT32 minor = revision & 0xffff;
    Print(L"ZADAROVA KOROVA\r\n");

    return EFI_SUCCESS;
}
