#  AES 對稱式加密

## PHP部分

```php
function encrypt($key, $payload)
{
    $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length('aes-256-cbc'));
    $encrypted = openssl_encrypt($payload, 'aes-256-cbc', $key, 0, $iv);
    return base64_encode($encrypted . '::' . $iv);
}

function decrypt($key, $garble)
{
    list($encrypted_data, $iv) = explode('::', base64_decode($garble), 2);
    return openssl_decrypt($encrypted_data, 'aes-256-cbc', $key, 0, $iv);
}

echo $encode = encrypt("364fa0bde7235182b8c003ff4cbbbcee", "PassPWDAABCD"); //UFVBUHltcDYxRjc4NUt4Y0hBSDZjdz09Ojob6r5lMoaBdo/lPT4Jw+0D
echo $decode = decrypt("364fa0bde7235182b8c003ff4cbbbcee", $encode); //PassPWDAABCD
```
* `openssl_encrypt` 與 `openssl_decrypt`的 option 代表意思 :
    * 0 默認值 使用 PKCS7 填充算法，對加密結果進行 base64encode
    * 1 OPENSSL_RAW_DATA 使用 PKCS7 填充算法，不對加密結果進行 base64encode
    * 2 OPENSSL_ZERO_PADDING 使用 null('\0') 進行填充，且對加密結果進行 base64encode



* 參考:
  * https://www.ucamc.com/e-learning/php/388-php%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8aes-openssl%E5%8A%A0%E5%AF%86%E4%BB%A3%E7%A2%BC
  * https://segmentfault.com/a/1190000018059273
  * https://www.php.net/manual/en/function.openssl-encrypt.php
  * https://www.php.net/manual/en/function.openssl-decrypt.php
