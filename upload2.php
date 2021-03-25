<html>
root@608fca12053a:/var/www/html/data# cd ../R/
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>sample</title>
</head>
<body>
<p><?php

date_default_timezone_set('Asia/Tokyo');
$nowtime = date("Ymd-His");
shell_exec("mkdir /var/www/html/data/$nowtime");

$updir = "../data/$nowtime";
$tmp_file = @$_FILES['upfile']['tmp_name'];
@list($file_name,$file_type) = explode(".",@$_FILES['upfile']['name']);
$copy_file = input . "." . $file_type;
if (is_uploaded_file($_FILES["upfile"]["tmp_name"])) {
    if (move_uploaded_file($tmp_file,"$updir/$copy_file")) {
        chmod("upload_files/" . $_FILES["upfile"]["name"], 0644);
        echo $_FILES["upfile"]["name"] . "をアップロードしました。<br />";
        echo "（※アップロードしたファイルは <a href=\"" . $updir . "/" . $copy_file . "\" target=\"_blank\">こちら</a> から確認できます。）";
        echo "（※生成されたファイルは <a href=" .$updir.".zip".">こちら</a> からダウンロードできます。）";
    } else {
        echo "ファイルをアップロード出来ませんでした。";
    }
} else {
    echo "ファイルが選択されていません。";
}

shell_exec("sh ../R/ryukyu.sh $nowtime");
$current_dir = shell_exec("pwd");
chdir("../data");
shell_exec("zip -r $nowtime.zip $nowtime");
chdir("$current_dir");

?></p>
</body>
</html>
