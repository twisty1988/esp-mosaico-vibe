# Source this file from zsh or bash: source ./env.sh
# Use an explicit SDK path when set, otherwise the standard local installation.
_mosaico_idf_path="${IDF_PATH:-$HOME/esp/esp-idf-7b9cc1a}"
if [ "$(git -C "$_mosaico_idf_path" rev-parse HEAD 2>/dev/null)" != "7b9cc1ac79f865983f59bb8ff3ff43eb74ff1dbe" ]; then
    printf '%s\n' 'ESP-Mosaico: set IDF_PATH to the required ESP-IDF checkout (7b9cc1ac79f865983f59bb8ff3ff43eb74ff1dbe).' >&2
    unset _mosaico_idf_path
    return 1
fi

export IDF_PATH="$_mosaico_idf_path"
unset _mosaico_idf_path
_mosaico_idf_python_env="${IDF_TOOLS_PATH:-$HOME/.espressif}/python_env/idf6.2_py3.11_env"
if [ -z "${IDF_PYTHON_ENV_PATH:-}" ] && [ -x "$_mosaico_idf_python_env/bin/python" ]; then
    export IDF_PYTHON_ENV_PATH="$_mosaico_idf_python_env"
fi
unset _mosaico_idf_python_env
if ! . "$IDF_PATH/export.sh"; then
    return 1
fi
export MOSAICO_IDF_PYTHON="$IDF_PYTHON_ENV_PATH/bin/python"
