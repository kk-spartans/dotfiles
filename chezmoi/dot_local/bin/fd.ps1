param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

fd --unrestricted @Args
