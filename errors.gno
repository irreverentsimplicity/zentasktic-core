package zentasktic

import "errors"

var (
	ErrTaskNotEditable             	= errors.New("Task is not editable")
	ErrProjectNotEditable           = errors.New("Project is not editable")
	ErrProjectIdNotFound			= errors.New("Project id not found")
	ErrTaskIdNotFound				= errors.New("Task id not found")
	ErrProjectTasksNotFound			= errors.New("Could not get tasks for project")
	ErrTaskIdAlreadyExists			= errors.New("A task with the provided id already exists")
	ErrTaskByIdNotFound				= errors.New("Can't get task by id")
	ErrTaskNotRemovable				= errors.New("Cannot remove a task directly from this realm")
	ErrTaskNotRemoved				= errors.New("Task was not removed")
	ErrTaskNotInAssessRealm			= errors.New("Task is not in Assess, cannot edit Body")
	ErrContextIdAlreadyExists		= errors.New("A context with the provided id already exists")
	ErrContextIdNotFound			= errors.New("Context id not found")
	ErrContextNotRemoved			= errors.New("Context was not removed")
	ErrObjectPathNotUpdated			= errors.New("Object path wasn't updated")
)