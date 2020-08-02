function get-dlmember
{
    param(
            [string[]]$groupname
         )
    BEGIN{}
    PROCESS
    {
        foreach($group in $groupname)
        {
            if($Global:dlcheck -notcontains $group)
            {
                $checking = get-recipient -identity $group
                if($checking.RecipientTypeDetails -match "Group")
                {
                    Write-Host "checking for group" $checking.Primarysmtpaddress
                    $memberinf = Get-DistributionGroupMember -Identity $checking.Primarysmtpaddress
                    $memberinfi = $memberinf.Primarysmtpaddress
                
                    $Global:dlcheck += $checking.Primarysmtpaddress -split ' '
                    get-dlmember -groupname  $memberinfi
                    
                }
                else
                {
                    Get-Member -users $checking.Primarysmtpaddress
                }
            }
            
        }
    }
    END{}
}

function get-member
{
    param(
            [string[]]$users
         )

    BEGIN{}
    PROCESS
    {
        foreach($user in $users)
        {
            if($Global:finded_all -notcontains $user)
            {
                Write-Host "Checking for " $user
                $checkinmember = Get-recipient -identity $user
                $Find = $checkinmember.primarysmtpaddress
            
                $Global:finded += $Find +';'
                $Global:finded_all += $user -split ' '
            }
        }
    }
    END{}
}