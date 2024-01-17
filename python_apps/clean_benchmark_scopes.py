import subprocess

PRAVEGA_CLI = "/home/raul/Documents/workspace/nct-video-analytics/pravega/build/distributions/pravega-0.14.0-3269.a6bba01-SNAPSHOT/"

if __name__ == "__main__":
    command = ["bash", PRAVEGA_CLI + "bin/pravega-cli", "scope", "list"]
    output = subprocess.run(command, check=True, capture_output=True, text=True)
    for output_scope in output.stdout.splitlines():
        output_scope = output_scope.strip()
        if output_scope.startswith("benchmark"):
            print(output_scope)
            command = ["bash", PRAVEGA_CLI + "bin/pravega-cli", "stream", "list", output_scope]
            output = subprocess.run(command, check=True, capture_output=True, text=True)
            for output_stream in output.stdout.splitlines():
                output_stream = output_stream.strip()
                if output_stream.startswith(output_scope + "/latency"):
                    print("Deleting stream: " + output_stream)
                    command = ["bash", PRAVEGA_CLI + "bin/pravega-cli", "stream", "delete", output_stream]
                    output = subprocess.run(command, check=True, capture_output=True, text=True)

            print("Deleting scope: " + output_scope)
            command = ["bash", PRAVEGA_CLI + "bin/pravega-cli", "scope", "delete", output_scope]
            output = subprocess.run(command, check=True, capture_output=True, text=True)