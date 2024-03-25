// base implementation
package zentasktic_core

import (
	"strconv"
	"errors"
)


type Context struct {
	Id 			string `json:"contextId"`
	Name 		string `json:"contextName"`
}

var (
	Contexts avl.Tree // contextId -> Context
)

// actions

func () AddContext(string contextId, string contextName) (err error) {
	// implementation
	newContext := &Context{
		ID: contextId,
		Name: contextName,
	}
	Contexts.Set(contextId, newContext)
	return nil
}

func () EditContext(string contextId, string newContextName) (err error){
	context, err = contexts.Get(contextId)
	if err != nil {
		return err
	}
	editedContext := &Context{
		ID: contextId,
		Name: newContextName,
	}
	Contexts.Set(contextId, editedContext)
	return nil
}

func () RemoveContext(string contextId) (err error) {
	// implementation
	context, err = contexts.Get(contextId)
	if err != nil {
		return err
	}
	Contexts.Remove(contextId)
}

func () AddContextToTask(string contextId, string taskId) (err error) {
	// implementation

	// check if task exists
	task, terr := tasks.Get(taskId)
	if terr != nil {
		return terr
	}
	// check if context exists
	context, cerr := contexts.Get(contextId)
	if cerr != nil {
		return cerr
	}

	editedTask := &Task {
		Id: task.Id
		ProjectId: task.ProjectId
		ContextId: contextId
		RealmId: task.RealmId
		Body: task.Body
		Due: task.Due
		Alert: task.Alert
	}
	// check to see if task is editable -> RealmId = 1 (Assess)
	if editedTask.RealmId == 1 {
		Tasks.Set(taskId, editedTask)
	}
	else {
		return ErrTaskNotEditable
	}

	return nil
}

func () AddContextToProject(string contextId, string projectId) (err error) {
	// check if project exists
	project, perr := projects.Get(projectId)
	if perr != nil {
		return perr
	}
	// check if context exists
	context, cerr := contexts.Get(contextId)
	if cerr != nil {
		return cerr
	}

	editedProject := &Project {
		Id: project.ProjectId
		ContextId: contextId	
		RealmId: project.RealmId
		Body: project.Body
		Due: project.Due
	}
	// check to see if task is editable -> RealmId = 1 (Assess)
	if editedProject.RealmId == 1 {
		Projects.Set(taskId, editedProject)
	}
	else {
		return ErrProjectNotEditable
	}
	
	return nil
}

// getters

func () GetContexts() (contexts string, err error) {
	// implementation
	
}