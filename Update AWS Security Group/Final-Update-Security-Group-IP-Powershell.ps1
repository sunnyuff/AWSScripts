# Run the script and press arrow down to see output
$SecurityGroupID = "sg-xxxxxxxxxx"
$region = "us-east-1"

$ipinfo = Invoke-RestMethod http://ipinfo.io/json

$IP = $ipinfo.ip
 
$sg = aws ec2 describe-security-groups --group-id $SecurityGroupID  --region $region
$JSON = $sg | ConvertFrom-Json
$JSON.SecurityGroups.IpPermissions.IpRanges

Read-Host -Prompt "Enter to continue, (Below Security Group Before Updation)"

Write-Host "1: Press '1' for Insert."
Write-Host "2: Press '2' for Update."

$input = Read-Host "Please make a selection"

if (($input -eq 1)) {
	$PORT = Read-Host "Please enter the port"
	$DESC = Read-Host "Please make the description"
	aws ec2 authorize-security-group-ingress --group-id $SecurityGroupID --ip-permissions "IpProtocol=tcp,FromPort=$PORT,ToPort=$PORT,IpRanges=[{CidrIp=$IP/32,Description=$DESC}]" --region $region
	$sg = aws ec2 describe-security-groups --group-id $SecurityGroupID  --region $region
	$JSON = $sg | ConvertFrom-Json
	$JSON.SecurityGroups.IpPermissions.IpRanges
	Read-Host -Prompt "Enter to continue, (Above Security Group After Updation)"
 }
 elseif ($input -eq 2) {
	$Name = Read-Host -Prompt 'Input the user name'
	ForEach($i in $JSON.SecurityGroups.IpPermissions) {
		ForEach($j in $i.IpRanges | Where{$_.Description -like "$Name*"}) {
			aws ec2 revoke-security-group-ingress --group-id $SecurityGroupID --region $region --protocol $i.IpProtocol --port $i.FromPort --cidr $j.CidrIp 
			aws ec2 authorize-security-group-ingress --group-id $SecurityGroupID --region $region --ip-permissions "IpProtocol='$($i.IpProtocol)',FromPort='$($i.FromPort)',ToPort='$($i.ToPort)',IpRanges=[{CidrIp=$IP/32,Description='$($j.Description)'}]"
		}
	}
	$sg = aws ec2 describe-security-groups --group-id $SecurityGroupID  --region $region
	$JSON = $sg | ConvertFrom-Json
	$JSON.SecurityGroups.IpPermissions.IpRanges
	Read-Host -Prompt "Enter to continue, (Above Security Group After Updation)"
 }
 else {
	Write-Host "Please enter vaild selection"
 	exit
 }
Read-Host -Prompt "Enter to exit"