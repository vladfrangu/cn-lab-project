build:
	@echo "Building the project"
	@mkdir -p dist
	@rm -rf dist/*
	@echo "Compiling the project"
	iverilog -o ./dist/alu src/**/*.v
	@echo "Project compiled successfully"

clean:
	@echo "Cleaning the project"
	@rm dist/alu
	@echo "Project cleaned successfully"
