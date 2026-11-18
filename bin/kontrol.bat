@echo off
chcp 65001 >nul
ruby test/ogrenci_test.rb
if %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
