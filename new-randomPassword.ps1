<#
.SYNOPSIS
    Create a new random password
.DESCRIPTION
    Create a new random password of a given length using different cases, numbers, and symbols as requested.
.EXAMPLE
    #Return a 20 character password with upper/lower case letters, numbers, and symbols
    New-RandomPassword
.EXAMPLE
    #Return a 15 character password with no numbers included
    New-RandomPassword -Length 15 -UseNumbers $false
.EXAMPLE
    #Return a 25 character password with only numbers
    25 | New-RandomPassword -UseSymbols $false -UseLowerCase $false -UseUpperCase $false
.INPUTS
    The password length can be passed via the pipleline
.OUTPUTS
    A string of random characters
.NOTES
    Presence of a symbol, uppercase, lowercase, or number is not yet guaranteed in the result, even if the flag is set.
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
#>
function New-RandomPassword {
    Param (
        # Length of the Random Password. Default is 20 characters.
        [Parameter(Position=0,
                   ValueFromPipeline=$true)]
        [int]$Length=20,
        # When set to false, don't include Symbols in the output. Default is $true so symbols are included.
        [Parameter(Position=1,
                   ValueFromPipeline=$false)]
        [bool]$UseSymbols=$true,
        # When set to false, don't include lower case letters in the output. Default is $true so lower case letters are included.
        [Parameter(Position=2,
                   ValueFromPipeline=$false)]
        [bool]$UseLowerCase=$true,
        # When set to false, don't include UPPER CASE letters in the output. Default is $true so upper case letters are included.
        [Parameter(Position=3,
                   ValueFromPipeline=$false)]
        [bool]$UseUpperCase=$true,
        # When set to false, don't include numbers in the output. Default is $true so numbers are included.
        [Parameter(Position=4,
                   ValueFromPipeline=$false)]
        [bool]$UseNumbers=$true
    )
    #Build the character set, based on the flags that have been provided.
    $characterSet=$null
    If ($UseLowerCase){$characterSet=$characterSet+(97..122 | ForEach-Object{[char]$_})}
    If ($UseUpperCase){$characterSet=$characterSet+(65..90 | ForEach-Object{[char]$_})}
    If ($UseSymbols){$characterSet=$characterSet+(35..38 | ForEach-Object{[char]$_})+ (58..64 | ForEach-Object{[char]$_})+(40..46 | ForEach-Object{[char]$_})}
    If ($UseNumbers){$characterSet=$characterSet+(0..9)}
    #Check we have some characters to use
    if ($characterSet){
        #Make sure the concatanated character set is longer than the required length. At least five times as long.
        #This means we can do passwords over 10 characters when using numbers only etc.
        while($characterSet.Count -lt $length*5) {
            $characterSet=$characterSet+$characterSet
        }
        #Output a random string of the required length from the concatanated character set
        $characterSet | Get-Random -count $length  | Join-String
    } else {
        #In this case the script has been called with no numbers, letters, symbols wanted.
        #TODO Throw a sensible error.
        "correcthorsebatterystaple"
    }
}