<?php
require('../vendor/autoload.php');

$token = $_POST['stripeToken'];
$amount = $_POST['amount'];

try{
\Stripe\Stripe::setApiKey("sk_live_YtbeTsvtT6iprMeftcgEy8WN");

\Stripe\Charge::create(array(
    "amount" => round($amount * 100), // amount in cents, again
    "currency" => "gbp",
    "source" => $token,
    "description" => "Ronald Yule Donation Payment",
));
} catch (Stripe_CardError $e) {
    // Since it's a decline, Stripe_CardError will be caught
    $body = $e->getJsonBody();
    $err  = $body['error'];

    echo 'Status is:' . $e->getHttpStatus() . "\n";
    echo 'Type is:' . $err['type'] . "\n";
    echo 'Code is:' . $err['code'] . "\n";
    // param is '' in this case
    echo 'Param is:' . $err['param'] . "\n";
    echo 'Message is:' . $err['message'] . "\n";
} catch (Exception $e) {
    echo $e->getMessage();
} catch (ErrorException $e) {
    echo $e->getMessage();
}