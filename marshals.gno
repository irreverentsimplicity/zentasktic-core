package zentasktic_core

import (
	"strconv"
	"bytes"
	"errors"
	"std"
)


type Contexts struct {
	Items	[]Context
}

type Tasks struct {
	Items	[]Task
}

type Projects struct {
	Items	[]Project
}

type Collections struct {
	Items	[]Collection
}

func (c Context) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"contextId":"`)
	b.WriteString(c.Id)
	b.WriteString(`",`)

	b.WriteString(`"contextName":"`)
	b.WriteString(c.Name)
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (cs Contexts) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	c.WriteString(`{"contexts":[`)
	for i, context := range cs.Items {
		if i > 0 {
			b.WriteString(`,`)
		}
		contextJSON, cerr := context.MarshalJSON()
		if cerr != nil {
			b.WriteString(contextJSON)
		}
	}
	b.WriteString(`]}`)

	return b.Bytes(), nil
}

func (t Task) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"taskId":"`)
	b.WriteString(t.Id)
	b.WriteString(`",`)

	b.WriteString(`"taskProjectId":"`)
	b.WriteString(t.taskProjectId)
	b.WriteString(`",`)

	b.WriteString(`"taskContextId":"`)
	b.WriteString(t.ContextId)
	b.WriteString(`",`)

	b.WriteString(`"taskRealmId":"`)
	b.WriteString(t.RealmId)
	b.WriteString(`",`)

	b.WriteString(`"taskBody:"`)
	b.WriteString(t.Body)
	b.WriteString(`",`)

	b.WriteString(`"taskDue":"`)
	b.WriteString(t.Due)
	b.WriteString(`",`)

	b.WriteString(`"taskAlert":"`)
	b.WriteString(t.Alert)
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (ts Tasks) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	c.WriteString(`{"tasks":[`)
	for i, task := range ts.Items {
		if i > 0 {
			b.WriteString(`,`)
		}
		taskJSON, cerr := task.MarshalJSON()
		if cerr != nil {
			b.WriteString(taskJSON)
		}
	}
	b.WriteString(`]}`)

	return b.Bytes(), nil
}


func (p Project) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"projectId":"`)
	b.WriteString(p.Id)
	b.WriteString(`",`)

	b.WriteString(`"projectContextId":"`)
	b.WriteString(p.ContextId)
	b.WriteString(`",`)

	b.WriteString(`"projectRealmId":"`)
	b.WriteString(p.RealmId)
	b.WriteString(`",`)

	b.WriteString(`{"projectTasks":[`)
	for i, projectTasks := range p.Tasks {
		if i > 0 {
			b.WriteString(`,`)
		}
		projectTasksJSON, perr := projectTasks.MarshalJSON()
		if perr != nil {
			b.WriteString(projectTasksJSON)
		}
	}
	b.WriteString(`],`)

	b.WriteString(`"projectBody:"`)
	b.WriteString(p.Body)
	b.WriteString(`",`)

	b.WriteString(`"projectDue":"`)
	b.WriteString(p.Due)
	b.WriteString(`"`)

	b.WriteByte('}')

	return b.Bytes(), nil
}

func (ps Projects) MarshalJSON() ([]byte, error) {
	var b bytes.Buffer

	c.WriteString(`{"projects":[`)
	for i, project := range ps.Items {
		if i > 0 {
			b.WriteString(`,`)
		}
		projectJSON, perr := project.MarshalJSON()
		if perr != nil {
			b.WriteString(projectJSON)
		}
	}
	b.WriteString(`]}`)

	return b.Bytes(), nil
}

func (c Collection) MarshalJSON() ([]byte, error) {

	var b bytes.Buffer
	
	b.WriteByte('{')

	b.WriteString(`"collectionId":"`)
	b.WriteString(c.Id)
	b.WriteString(`",`)

	b.WriteString(`"collectionName":"`)
	b.WriteString(c.Name)
	b.WriteString(`",`)

	b.WriteString(`{"collectionTasks":[`)
	for i, collectionTasks := range c.Tasks {
		if i > 0 {
			b.WriteString(`,`)
		}
		collectionTasksJSON, perr := collectionTasks.MarshalJSON()
		if perr != nil {
			b.WriteString(collectionTasksJSON)
		}
	}
	b.WriteString(`],`)

	b.WriteString(`{"collectionProjects":[`)
	for i, collectionProjects := range c.Projects {
		if i > 0 {
			b.WriteString(`,`)
		}
		collectionProjectsJSON, perr := collectionProjects.MarshalJSON()
		if perr != nil {
			b.WriteString(collectionProjectsJSON)
		}
	}
	b.WriteString(`],`)

	b.WriteByte('}')

	return b.Bytes(), nil
}
