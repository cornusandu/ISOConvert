import subprocess, pathlib, shutil

def convert(input_path, target_type):
    input_path = pathlib.Path(input_path)
    ext = input_path.suffix.lower()

    if ext == ".cso" and target_type == "iso":
        return cso_to_iso(input_path)
    elif ext == ".iso" and target_type == "cso":
        return iso_to_cso(input_path)
    elif ext == ".iso" and target_type == "folder":
        return iso_to_folder(input_path)
    elif input_path.is_dir() and target_type == "iso":
        return folder_to_iso(input_path)
    else:
        raise ValueError(f"Unsupported conversion: {ext} → {target_type}")

# Dependencies above:
def cso_to_iso(p): p = pathlib.Path(p); subprocess.run(["maxcso", "--decompress", str(p), "-o", p.with_suffix(".iso")], check=True); return p.with_suffix(".iso")
def iso_to_cso(p): p = pathlib.Path(p); subprocess.run(["maxcso", str(p), "-o", p.with_suffix(".cso")], check=True); return p.with_suffix(".cso")
def iso_to_folder(p, o=None): p = pathlib.Path(p); import os; o=o or p.stem+"_extracted"; subprocess.run(["7z","x",str(p),f"-o{o}"],check=True); return pathlib.Path(o)
def folder_to_iso(p, o=None): p = pathlib.Path(p); o=o or p.with_suffix(".iso"); subprocess.run(["mkisofs","-o",str(o),str(p)],check=True); return pathlib.Path(o)
