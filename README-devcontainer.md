# Assignment:  Bash Script Implementation (Dev Container)

This guide helps you run the **Bash Script Implementation** Assignment in a consistent Python environment using **Visual Studio Code** and **Dev Containers**.

---

## ✅ Prerequisites

1. Install [Visual Studio Code](https://code.visualstudio.com/)
2. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
3. Install these VS Code extensions:
   - `Dev Containers`

---

### **Installing the Dev Containers Extension**

1. **Open VS Code**.

2. **Access the Extensions View**:
   
   - Click on the **Extensions** icon in the Activity Bar on the side of the window.
   
   - Or press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS).

3. **Search for the Extension**:
   
   - In the Extensions view search bar, type `Dev Containers`.

4. **Install the Extension**:
   
   - Locate **Dev Containers** by Microsoft in the search results.
   
   - Click the **Install** button.

---

## 📁 Folder Structure

```
Assignments-folder/
├── .devcontainer/
│   └── devcontainer.json
│   └── Dockerfile
├── solution-shell-automation.md
├── README-devcontainer
├── 
└── Code/solution
      └──  solution-shell-automation  # solution guide
      └──  file_processor.sh           #Solution code 
      └──  test_file_processor.sh      # the script to test the solution code     
```

---

## Open in Dev Container

1. Open VS Code
2. Go to: **File** → **Open Folder...**
3. Select `Assignments/Solution/`
4. VS Code will prompt you to reopen in container. Click **Yes**.
   If not prompted:
   - Press `Ctrl+Shift+P` → `Dev Containers: Reopen in Container`

---

## Run  solution code

- In VS Code, click the ➕ icon in the terminal tab to open a **new terminal** OR `Ctrl+Shift+`.

- go to `Code` directory 
  
  ```bash
  cd Code 
  ```

- name the solution script `file_processor.sh` and copy it to the `Code` directory. 

- run the testing script `test_file_processor.sh` thet  automates testing for your Bash file processing assignment by simulating real scenarios and scoring your script’s behavior. Here's a breakdown of what it does and why:

```bash
./test_file_processor.sh
```
