function ConvertTo-IdObjects() {

	param(
		$IDs
	)

	$CompileArray = @()

        $IDs | Foreach-Object { 

            $EPMObject = @{ Id = $_ }

            $CompileArray += $EPMObject

        }

        Return $CompileArray
}
