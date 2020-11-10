
TEST_MSG = "test log message"

@testset "Test configure_logging" begin
    # Verify logging to a file.
    logfile = "testlog.txt"
    isfile(logfile) && rm(logfile)

    try
        logger = configure_logging(
            console_level = Logging.Warn,
            file_level = Logging.Debug,
            filename = logfile,
        )
        with_logger(logger) do
            @info TEST_MSG
        end

        close(logger)
        @test isfile(logfile)
        lines = readlines(logfile)
        @test length(lines) == 2  # two lines per message
        @test occursin(TEST_MSG, lines[1])
    finally
        rm(logfile)
    end

    # Verify logging with no file.
    logger = configure_logging(
        console_level = Logging.Warn,
        file_level = Logging.Info,
        filename = nothing,
    )
    with_logger(logger) do
        @info TEST_MSG
    end

    close(logger)
    @test !isfile(logfile)
end
