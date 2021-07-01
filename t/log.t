use Test2::V0;
use SDL2::Raw;
use Capture::Tiny 'capture_stderr';

sub test_output (&$$) {
    my ( $code, $want, $msg ) = @_;
    my ($out) = capture_stderr { $code->() };
    chomp $out;
    is $out, $want, $msg // '';
}

SDL2::LogSetAllPriority( SDL2::LOG_PRIORITY_VERBOSE );

is SDL2::LogGetPriority(0), SDL2::LOG_PRIORITY_VERBOSE,
    'Could set log priority';

test_output { SDL2::Log(           'Default %d', 10 ) } 'INFO: Default 10',    'SDL2::Log';
test_output { SDL2::LogVerbose( 0, 'Verbose %d', 10 ) } 'VERBOSE: Verbose 10', 'SDL2::LogVerbose';
test_output { SDL2::LogDebug(   0, 'Debug %d',   10 ) } 'DEBUG: Debug 10',     'SDL2::LogDebug';
test_output { SDL2::LogInfo(    0, 'Info %d',    10 ) } 'INFO: Info 10',       'SDL2::LogInfo';
test_output { SDL2::LogWarn(    0, 'Warn %d',    10 ) } 'WARN: Warn 10',       'SDL2::LogWarn';
test_output { SDL2::LogError(   0, 'Error %d',   10 ) } 'ERROR: Error 10',     'SDL2::LogError';

SDL2::LogResetPriorities;

isnt SDL2::LogGetPriority(0), SDL2::LOG_PRIORITY_VERBOSE,
    'Could reset log priority';

test_output { SDL2::Log(           'Default %d', 10 ) } 'INFO: Default 10',    'SDL2::Log';
test_output { SDL2::LogVerbose( 0, 'Verbose %d', 10 ) } '',                    'SDL2::LogVerbose';
test_output { SDL2::LogDebug(   0, 'Debug %d',   10 ) } '',                    'SDL2::LogDebug';
test_output { SDL2::LogInfo(    0, 'Info %d',    10 ) } 'INFO: Info 10',       'SDL2::LogInfo';
test_output { SDL2::LogWarn(    0, 'Warn %d',    10 ) } 'WARN: Warn 10',       'SDL2::LogWarn';
test_output { SDL2::LogError(   0, 'Error %d',   10 ) } 'ERROR: Error 10',     'SDL2::LogError';

test_output {
    SDL2::LogMessage( 0, SDL2::LOG_PRIORITY_CRITICAL, 'Critical %d', 10 )
} 'CRITICAL: Critical 10', 'SDL2::LogMessage';

done_testing;
