package zentasktic_core

import "errors"

var (
	ErrTaskNotEditable             	= errors.New("Task is not editable")
	ErrProjectNotEditable           = errors.New("Project is not editable")
	ErrProjectIdNotFound			= errors.New("Project id not found")
	ErrTaskIdNotFound				= errors.New("Task id not found")
	ErrProjectTasksNotFound			= errors.New("Could not get tasks for project")
	ErrTaskIdAlreadyExists			= errors.New("A task with the provided id already exists")
)