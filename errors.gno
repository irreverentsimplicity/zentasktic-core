package zentasktic_core

import "errors"

var (
	ErrTaskNotEditable             	= errors.New("Task is not editable")
	ErrProjectNotEditable           = errors.New("Project is not editable")
)