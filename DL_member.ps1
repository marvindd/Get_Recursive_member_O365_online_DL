$date = Get-Date -Format dd.MM.yy-hh.mm.ss
$scriptpath = $PSScriptRoot
$Distro = gc -Path "$scriptpath\input\email.txt"
$finalout = @()
foreach($Distri in $Distro)
{
    $email = $Distri
    $Distribution = Get-DistributionGroup -Identity $email -ErrorAction silentlycontinue
    if($Distribution -ne $null)
    {
        Write-Host "Cheking for the user $Distri" -fore Cyan
        $member = Get-DistributionGroupMember -Identity $Distri
        $report = $member.Primarysmtpaddress
        $finded = $null
                
	    . "$scriptpath\module\get-dlmember.ps1"
	    #finding member of the Distribution group
        $Global:finded = $null
        $Global:finded_all = $null
        $Global:dlcheck = $null
        #get-dlmember -groupname $report
        get-dlmember -groupname $Distri
        $gpmember = $Global:finded

        $obj = new-object psobject
        $obj | add-member -membertype noteproperty -Name "DistributionEmail" -value $Distribution.Primarysmtpaddress
        $obj | add-member -membertype noteproperty -Name "Displayname" -value $Distribution.Displayname
        $obj | add-member -membertype noteproperty -Name "Alias" -Value $Distribution.Alias
        $obj | add-member -membertype noteproperty -Name "recipienttypedetails" -Value $Distribution.RecipientTypeDetails
        $obj | add-member -membertype noteproperty -Name "Member" -value $gpmember
        $finalOut +=$obj
    }
    else
    {
        Write-Host "Unable to find Distribution group $Distri" -fore DarkRed
        $obj = new-object psobject
        $obj | add-member -membertype noteproperty -Name "DistributionEmail" -value $Distri
        $obj | add-member -membertype noteproperty -Name "Displayname" -value "Unable to find this group"
        $obj | add-member -membertype noteproperty -Name "Alias" -Value ""
        $obj | add-member -membertype noteproperty -Name "recipienttypedetails" -Value ""
        $obj | add-member -membertype noteproperty -Name "Member" -value ""
        $finalOut +=$obj
    }
}
$finalout | Export-Csv -Path "$scriptpath\output\distribution.csv" -NoTypeInformation