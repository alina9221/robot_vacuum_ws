cmake_minimum_required(VERSION 3.8)
project(robot_vacuum)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
# Для Python-модулей
find_package(ament_cmake_python REQUIRED)
find_package(rclpy REQUIRED)
find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)
find_package(std_msgs REQUIRED)

# ---- C++ часть (если появится) ----
# include_directories(include)
# add_executable(cpp_node src/cpp_node.cpp)
# ament_target_dependencies(cpp_node rclcpp)
# install(TARGETS cpp_node DESTINATION lib/${PROJECT_NAME})

# ---- Python часть ----
# Устанавливаем Python-модули из папки robot_vacuum/
ament_python_install_package(${PROJECT_NAME})

# Устанавливаем Python-скрипты как исполняемые файлы
install(PROGRAMS
  nodes/dummy_sensor.py
  DESTINATION lib/${PROJECT_NAME}
)

# ---- Установка launch-файлов ----
install(DIRECTORY
  launch
  DESTINATION share/${PROJECT_NAME}
)

# ---- Установка конфигов ----
install(DIRECTORY
  config
  DESTINATION share/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_copyright_FOUND TRUE)
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
