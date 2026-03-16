param(
    [string]$Path = (Get-Location)
)

$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

Get-ChildItem -LiteralPath $Path -Force | ForEach-Object {
    $acl = Get-Acl $_.FullName
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $user,
        "FullControl",
        "Allow"
    )

    $acl.SetAccessRule($rule)
    Set-Acl -Path $_.FullName -AclObject $acl
}
