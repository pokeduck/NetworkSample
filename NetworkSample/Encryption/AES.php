<?php
function decrypt_aes($key, $garble)
{
    list($encrypted_data, $iv) = explode('::', base64_decode($garble), 2);

    return openssl_decrypt($encrypted_data, 'aes-256-cbc', $key, 0, $iv);
}
function encrypt_aes($key, $payload)
   {
       $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('aes-256-cbc'));
       $encrypted = openssl_encrypt($payload, 'aes-256-cbc', $key, 0, $iv);
       return base64_encode($encrypted . '::' . $iv);
   }
$key = "364fa0bde7235182b8c003ff4cbbbcee";
$data = 'PassPWDAABCD';
echo $encrypt = encrypt_aes($key, $data);
echo("\n");
echo $decrypt = decrypt_aes($key, $encrypt);
?>
