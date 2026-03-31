{
  commands = {
    code_analysis = ''
      Review and improve the entire codebase by identifying and removing unwanted or redundant code. Ensure each part of the code serves a purpose, adheres to best practices, and maintains functionality. Provide explanations for the changes made, highlighting the benefits of the improvements.

      ### Steps
      1. **Analyze the Code:** Go through each file and understand the functionality of the existing code.
      2. **Identify Redundancies:** Look for duplicated code or unnecessary complexity.
      3. **Remove Unwanted Code:** Delete any code that does not contribute to the overall functionality or is considered legacy.
      4. **Optimize Efficiently:** Refactor any convoluted parts of the code to improve clarity and performance.
      5. **Document Changes:** Keep a log of what was removed or changed and why.
      6. **Test Functionality:** Verify that the code still functions as intended after your changes.

      ### Output Format
      - Provide a summary of the areas you changed.
      - Include before-and-after code snippets for clarity.
      - Explain the reasoning behind each change made, with specific emphasis on improvements in efficiency, readability, or maintainability.

      ### Example
      - **Before:**
        ```
        function calculate(x, y) {
            return x + y;
        }
        ```
      - **After:**
        ```
        const sum = (x, y) => x + y;
        ```
      - **Reasoning:** Changed to an arrow function for conciseness and improved readability.
    '';
  };

  skills = {

  };
}
