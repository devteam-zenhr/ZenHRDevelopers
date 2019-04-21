---
layout: post
title:  "API Documentation"
style: bootstrap.css
---
<div class="row">
<div class="col-lg-3 col-md-3 col-xs-12 col-sm-12" id="overflow">
<div id="sidebar">
<div markdown='1'>
* Table of Content
{:toc}
</div>
</div>
</div>
<div class="col-lg-9 col-md-9 col-xs-12" markdown='1'>

### Overview

<div style='padding-left: 15px'>
Our API is based on <b>JWT</b> (JSON Web Token), we use <b>JWT (HS256 - HMAC using SHA-256 hash algorithm)</b>

In order to start the integration you need to generate <b>secret</b> and <b>key </b>tokens.

The <b>Key </b>will be used to identify your request and the <b>Secret </b>will be used for encoding and decoding your <b>payload</b>.

</div>
### Getting started

<div style='padding-left: 15px'>
  First you need to login to<b> ZenHR </b>to generate your key and secret tokens

  <ol>
    <li>
      <h4>Go to settings</h4>
      <br>
      <img src='/images/0.png' width='85%'>
    </li>
  <br>
  <br>
    <li>
      <h4>Select API Keys tab</h4>
      <br>
      <img src='/images/1.png' width='85%'>
    </li>
  <br>
  <br>
    <li>
      <h4>Click on (+ Add) button to add new key and secret</h4>
      <ul style= 'width: 80%'>
        <li>
           The Name field is just a label to let you know which API Key is used for which integration
        </li>
        <li>
           The  Permissions field will be used to identify your allowed actions in your requests to ZenHR
        </li>
        <li>
           The IP Addresses field is optional, however; we highly recommend adding them, in that case we will not accept any request to your account other than the ones that come form your IP Addresses
        </li>
      </ul>
      <br>
      <p style='color: red'> Note: The IP Addresses must be splitted by comma in case you wanted to enter more that a single IP Address </p>
      <img src='/images/2.png' width='85%'>
    </li>
  <br>
  <br>
    <li>
      <h4>After Filling your fields, click on create to generate you API Keys</h4>
      <br>
      <img src='/images/3.png' width='85%'>
    </li>

  <br>
  <br>
    <li>
      <h4>Now That you have created you API Key successfully click on Copy Key and Copy Secret to copy them</h4>
      <br>
      <img src='/images/4.png' width='85%'>
    </li>

  </ol>
</div>


### Authentication

In every request you make to <b>ZenHR</b> you need to do the following:
<ul>
  <li>
    Add the your <b>key</b> to the header
  <br>
    <b>example: <pre>{ key: “dgRp1eC2kAGEIYxRR4GKy-drze_Q6chskxebX__7Yjc” }</pre></b>
  </li>
  <li>
    Your payload must be <b>encoded</b>  using the <b>secret</b> and set in the <b>body</b>
  </li>
  <li>
    You should add your <b>key</b> to your <b>payload</b> before encoding it.
  </li>
</ul>

#### Example:
  your payload should follow the below structure:

  <table class="table table-condensed" style="width: 70%">
    <thead>
      <tr>
        <th scope="col">
          Pyload parameters key
        </th>
        <th scope="col">
          Description
        </th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>
          params
        </td>
        <td>
          Json params ex: {:employee_id=>1}
        </td>
      </tr>
      <tr>
        <td>
          key
        </td>
        <td>
          The Identifier Key which was generated in the setting in your ZenHR account
        </td>
      </tr>
    </tbody>
  </table>

#### Example:
<pre><b>{:params=>{:employee_id=>1}, :key=>"YOUR KEY"}</b></pre>

<b>then encrypt the payload using the API secret which related to the same key.</b>
<p style='color: red;'>
  You should note that you have a limit of 500 request everyday.
</p>

### Encoding and Decoding

#### Ruby:
Install JWT Gem
<pre>
sudo gem install jwt
</pre>

<pre>
hmac_secret = 'YOUR SECRET'

token = JWT.encode payload, hmac_secret, 'HS256'

puts token
# eyJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoidGVzdCJ9.pNIWIL34Jo13LViZAJACzK6Yf0qnvT_BuwOxiMCPE-Y

decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }

puts decoded_token
# Array
# [
#   {"data"=>"test"}, # payload
#   {"alg"=>"HS256"} # header
# ]
</pre>

#### PHP:
install JWT using Composer
<pre>
  composer require mishal/jwt
</pre>

<pre>

<?php
/*
 * This file is part of Jwt for Php.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

require_once __DIR__ . '/../vendor/autoload.php';

use Jwt\Jwt;
use Jwt\Algorithm\HS256Algorithm;

$token = Jwt::encode('string', $alg = new HS256Algorithm('secret'));

echo $token; // eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjoic3RyaW5nIn0.RncJbCyf4zd0pu1N02u_rKwEezkmd94r3i5sWLk1ceU

// decode, you must passed allowed algorithm(s) to prevent attackers to control the choice of algorithm
$decoded = Jwt::decode($token, ['algorithm' => $alg]);

echo $decoded['data']; // 'string'
</pre>

#### PAYTHON

<pre>

import chilkat

#  Demonstrates how to create an HMAC JWT using a shared secret (password).

#  This example requires the Chilkat API to have been previously unlocked.
#  See Global Unlock Sample for sample code.

jwt = chilkat.CkJwt()

#  Build the JOSE header
jose = chilkat.CkJsonObject()

success = jose.AppendString("alg","HS256")
success = jose.AppendString("typ","JWT")

#  Now build the JWT claims (also known as the payload)
claims = chilkat.CkJsonObject()
success = claims.AppendString("iss","http://example.org")
success = claims.AppendString("sub","John")
success = claims.AppendString("aud","http://example.com")

#  Set the timestamp of when the JWT was created to now.
curDateTime = jwt.GenNumericDate(0)
success = claims.AddIntAt(-1,"iat",curDateTime)

#  Set the "not process before" timestamp to now.
success = claims.AddIntAt(-1,"nbf",curDateTime)

#  Set the timestamp defining an expiration time (end time) for the token
#  to be now + 1 hour (3600 seconds)
success = claims.AddIntAt(-1,"exp",curDateTime + 3600)

#  Produce the smallest possible JWT:
jwt.put_AutoCompact(True)

strJwt = jwt.createJwt(jose.emit(),claims.emit(),"secret")

print(strJwt)
</pre>

### Requests and Respons
In order to fetch data use <b>GET</b> method
<br>
Don't forget to set your key in the header and your payload in the body

### Employees

In order to fetch all employees data
<br>
#### Payload example
<pre>
{ key: YOUR_KEY }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/employees
</pre>

for a single employee 
<br>
set your employee id in the payload inside params before you encode your payload

#### Payload example

<pre>
{ key: YOUR_KEY, params: { id: YOUR_EMPLOYEE_ID } }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/employee
</pre>

### Professional data


In order to fetch all employees professional data
<br>
#### Payload example
<pre>
{ key: YOUR_KEY }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/professional_data
</pre>

to get all professional data for a single employee
<br>
#### Payload example

<pre>
{ key: YOUR_KEY }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/YOUR_EMPLOYEE_ID/professional_data
</pre>

to get the current professional data for a single employee
<br>
#### Payload example

<pre>
{ key: YOUR_KEY }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/YOUR_EMPLOYEE_ID/professional_data/active
</pre>

### Financial data


In order to fetch all employees financial data
<br>
#### Payload example
<pre>
{ key: YOUR_KEY }
</pre>
<pre>
curl --header "key: YOUR_KEY" --data 'YOUR_ENCODED_PAYLOAD' --request GET https://www.zenhr.com/integration/v1/financial_data
</pre>
