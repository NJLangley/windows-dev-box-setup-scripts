# Original reference: https://gist.github.com/lalibi/3762289efc5805f8cfcf

function Set-WindowStyle {
	<#
	.LINK
	https://gist.github.com/jakeballard/11240204
	#>

	[CmdletBinding(DefaultParameterSetName = 'InputObject')]
	param(
		[Parameter(Position = 0, Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelinebyPropertyName = $True)]
		[Object[]] $InputObject,
		[Parameter(Position = 1)]
		[ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
		[string] $Style = 'SHOW'
	)

	BEGIN {
		$WindowStates = @{
			'FORCEMINIMIZE'   = 11
			'HIDE'            = 0
			'MAXIMIZE'        = 3
			'MINIMIZE'        = 6
			'RESTORE'         = 9
			'SHOW'            = 5
			'SHOWDEFAULT'     = 10
			'SHOWMAXIMIZED'   = 3
			'SHOWMINIMIZED'   = 2
			'SHOWMINNOACTIVE' = 7
			'SHOWNA'          = 8
			'SHOWNOACTIVATE'  = 4
			'SHOWNORMAL'      = 1
		}

$Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")] 
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow); 
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru
	
	}

	PROCESS {
		foreach ($process in $InputObject) {
		    $Win32ShowWindowAsync::ShowWindowAsync($process.MainWindowHandle, $WindowStates[$Style]) | Out-Null
		    Write-Verbose ("Set Window Style '{1} on '{0}'" -f $MainWindowHandle, $Style)
		}
	}
}

# Maximise the current shell. The first if for executing in a powershell window, the second is for the clickonce window
[System.Diagnostics.Process]::GetCurrentProcess() | Set-WindowStyle -Style MAXIMIZE
Get-Process -Name cmd | Set-WindowStyle -Style MAXIMIZE