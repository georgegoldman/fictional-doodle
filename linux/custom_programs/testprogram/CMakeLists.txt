add_executable(testprogram
    main.cpp
)

# Apply standard settings if defined
if(COMMAND apply_standard_settings)
    apply_standard_settings(testprogram)
endif()

# Link necessary libraries
target_link_libraries(testprogram PRIVATE flutter)
target_link_libraries(testprogram PRIVATE PkgConfig::GTK)