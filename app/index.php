<?php
$start = microtime(true);
$iterations = 50000;

$rustFacts = [
    "Rust would've done this in 0.0001s",
    "Memory safety without garbage collection",
    "Zero-cost abstractions (unlike PHP)",
    "Fearless concurrency (PHP is scared)",
    "Blazingly fast (PHP is blazingly slow)"
];

for ($i = 0; $i < $iterations; $i++) {
    $result = sqrt($i) * sin($i) * cos($i) * tan($i / max($i, 1));
}

$elapsed = microtime(true) - $start;
$rustFact = $rustFacts[array_rand($rustFacts)];

header('Content-Type: text/plain');
echo "🐘 PHP Performance Report\n";
echo str_repeat("=", 50) . "\n";
echo "Processed in: " . round($elapsed, 4) . "s\n";
echo "Hostname: " . gethostname() . "\n";
echo "Iterations: " . number_format($iterations) . "\n";
echo "\n";
echo "🦀 Rust says: " . $rustFact . "\n";
echo "\n";
echo "💡 But hey, PHP still powers the web! (80y programmers happy!)🌐\n";
?>