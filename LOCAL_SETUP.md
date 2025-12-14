# How to run this project locally in Visual Studio Code

## Prerequisites
1. **Node.js**: Make sure you have Node.js installed. You can download it from [nodejs.org](https://nodejs.org/). Version 18 or higher is recommended.
2. **Visual Studio Code**: The recommended code editor.

## Installation Steps

1. **Unzip the project**: Extract the downloaded zip file to a folder on your computer.
2. **Open in VS Code**: Right-click the folder and select "Open with Code" (or open VS Code and use File > Open Folder).
3. **Open Terminal**: In VS Code, press `Ctrl + ~` (tilde) to open the integrated terminal.
4. **Install Dependencies**: Run the following command to install all required libraries:
   ```bash
   npm install
   ```

## Running the Application

1. **Start the Development Server**:
   ```bash
   npm run dev
   ```
2. **Open in Browser**: The terminal will show a local URL (usually `http://localhost:5000` or `http://localhost:5173`). Ctrl+Click it to open the panel.

## Notes
- This is a **Frontend-Only** prototype.
- The "Backend" features (scanning, connecting) are simulated in the React code for demonstration purposes.
- To make it a real RAT/C2, you would need to implement a real backend server (Node.js/Python/Go) to replace the simulation logic in `client/src/pages/targets.tsx` and `client/src/pages/dashboard.tsx`.

## Project Structure
- `client/src/pages`: Contains the main views (Dashboard, Targets, Auth, etc.)
- `client/src/components`: UI components (Context Menu, Terminal, etc.)
- `client/src/App.tsx`: Main routing logic
