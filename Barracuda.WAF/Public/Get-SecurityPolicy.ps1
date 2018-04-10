<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
.COMPONENT
    The component this cmdlet belongs to
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    The functionality that best describes this cmdlet
.LINK
    https://campus.barracuda.com/product/webapplicationfirewall/api/9.1.1
#>
function Get-SecurityPolicy {
    [CmdletBinding()]
    [Alias()]
    [OutputType([PSCustomObject])]
    Param (
        # PolicyName help description
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]        
        [String[]]
        $PolicyName,

        # Groups help description
        [Parameter(Mandatory = $false)]
        [ValidateSet('Request Limits', 'URL Normalization', 'Parameter Protection', 'Cookie Security', 'Cloaking', 'URL Protection', 'Security Policy')]
        [String[]]
        $Groups,

        # Parameters help description
        [Parameter(Mandatory = $false)]
        [ValidateSet('based-on', 'name')]
        [String[]]
        $Parameters
    )

    process {
        try {
            $params = @{}

            if ($PSBoundParameters.ContainsKey('Groups')) {
                $params.groups = $Groups -join ','
            }

            if ($PSBoundParameters.ContainsKey('Parameters')) {
                $params.parameters = $Parameters -join ','
            }

            if ($PSBoundParameters.ContainsKey('PolicyName')) {
                foreach ($name in $PolicyName) {
                    Invoke-API -Path $('/restapi/v3/security-policies/{0}' -f $name) -Method Get -Parameters $params
                }
            } else {
                Invoke-API -Path '/restapi/v3/security-policies' -Method Get -Parameters $params
            }
        } catch {
            if ($_.Exception -is [System.Net.WebException]) {
                Write-Verbose "ExceptionResponse: `n$($_ | Get-ExceptionResponse)`n"
                if ($_.Exception.Response.StatusCode -ne 404) {
                    throw
                }
            } else {
                throw
            }
        }
    }
}