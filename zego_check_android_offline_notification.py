import os
import json


class AndroidConfigChecker:
    def __init__(self) -> None:
        self._google_service_json_path = "./android/app/google-services.json"
        self._project_gradle_path = "./android/build.gradle.kts"
        self._app_gradle_path = "./android/app/build.gradle.kts"

    def start_check(self):
        if self.is_google_service_json_in_right_location():
            print("✅ The google-service.json is in the right location.")
            if self.is_google_service_json_match_package_name():
                print("✅ The package name matches google-service.json.")
            else:
                print("❌ The package name does NOT match google-service.json.")
        else:
            print("❌ The google-service.json is NOT in the right location.")

        if self.is_project_gradle_correct():
            print("✅ The project level gradle file is ready.")
        else:
            print("❌ Missing dependencies in project-level gradle file.")

        if self.is_app_gradle_plugin_correct():
            print("✅ The plugin config in the app-level gradle file is correct.")
        else:
            print("❌ Missing com.google.gms.google-services plugin in the app-level gradle file.")

        if self.is_app_gradle_firebase_dependencies_correct():
            print("✅ Firebase dependencies config in the app-level gradle file is correct.")
        else:
            print("❌ Missing Firebase BoM dependencies in the app-level gradle file.")

        if self.is_app_gradle_firebase_messaging_dependencies_correct():
            print("✅ Firebase-Messaging dependencies config in the app-level gradle file is correct.")
        else:
            print("❌ Missing firebase-messaging dependencies in the app-level gradle file.")

    def is_google_service_json_in_right_location(self):
        return os.path.exists(os.path.abspath(self._google_service_json_path))

    def is_google_service_json_match_package_name(self):
        gs_path = os.path.abspath(self._google_service_json_path)
        package_name_list = []

        # قراءة google-services.json
        with open(gs_path, encoding="utf-8") as json_file:
            data = json.load(json_file)
            for c in data['client']:
                package_name = c["client_info"]["android_client_info"]["package_name"]
                package_name_list.append(package_name)

        # قراءة build.gradle.kts بدل AndroidManifest
        with open(os.path.abspath(self._app_gradle_path), encoding="utf-8") as file:
            content = file.read()

        for pkg in package_name_list:
            if pkg in content:
                return True

        return False

    def is_project_gradle_correct(self):
        with open(os.path.abspath(self._project_gradle_path), encoding="utf-8") as file:
            content = file.read()
            # دعم Kotlin DSL
            return "com.google.gms.google-services" in content

    def is_app_gradle_plugin_correct(self):
        with open(os.path.abspath(self._app_gradle_path), encoding="utf-8") as file:
            content = file.read()
            return "com.google.gms.google-services" in content

    def is_app_gradle_firebase_dependencies_correct(self):
        with open(os.path.abspath(self._app_gradle_path), encoding="utf-8") as file:
            content = file.read()
            # دعم Kotlin DSL
            return "firebase-bom" in content

    def is_app_gradle_firebase_messaging_dependencies_correct(self):
        with open(os.path.abspath(self._app_gradle_path), encoding="utf-8") as file:
            content = file.read()
            return "firebase-messaging" in content


if __name__ == "__main__":
    android_checker = AndroidConfigChecker()
    android_checker.start_check()