---
layout: blog
status: publish
published: true
url: /vuejs-state-management-using-pinia/
title: A Comprehensive Guide to Vue.js State Management using Pinia
description: Learn how to use Pinia for Vue.js states management LIKE A PRO with Examples for simplicity.
date: 2023-07-20T00:00:00-12:00
topics: [Web, Coding]
pick: [top]
excerpt_separator: <!--more-->
images:

  - url: /vuejs-state-management-using-pinia/hero.png
    alt: Vue.js State Management using Pinia
---

State management provides more straightforward ways for managing the data of your application. This concept is not limited to the most popular web frameworks such as [React.js](https://reactjs.org/) and Vue.js. States allow you to manage data predictably and consistently, especially in larger, more complex applications. In modern web development, it is common to use a state management library to help manage the state. State management libraries provide a central store and a set of methods for modifying and accessing an application state. In Vue.js, for example, the most common libraries for state management include Pinia and [Vuex](https://blog.openreplay.com/vuex-state-management-for-vue-projects/). This guide will teach you how to use [Pinia](https://pinia.vuejs.org/introduction.html) for Vue states management.
<!--more-->

- [Prerequisites](#prerequisites)
- [What is Pinia](#what-is-pinia)
- [How Pinia Works](#how-pinia-works)
- [Setting up Vue.js with Pinia](#setting-up-vuejs-with-pinia)
- [Creating a Pinia Store](#creating-a-pinia-store)
- [Adding Data to the Store](#adding-data-to-the-store)
- [Reading State Data from the Store](#reading-state-data-from-the-store)
- [Managing Pinia Getters](#managing-pinia-getters)
- [How to Persist State with Pinia](#how-to-persist-state-with-pinia)
- [Resetting the State](#resetting-the-state)
- [Conclusion](#conclusion)

### Prerequisites 

To comfortably follow allows this guide ensures, you have the:

- [Node.js runtime](https://nodejs.org/) installed on your computer.
- Basic knowledge of working with [Vue.js](https://vuejs.org/guide/introduction.html).
- [Vue.js devtools](https://devtools.vuejs.org/) installed in your browser.
- Basic knowledge of [Vuex](https://blog.openreplay.com/vuex-state-management-for-vue-projects/) will be an added advantage.

You can also jump ahead and get the code used along on this [GitHub repository](https://github.com/kimkimani/Vue.js-Pinia-Todo-App).

### What is Pinia

[Pinia](https://pinia.vuejs.org/introduction.html) is a lightweight state management library for Vue.js. Pinia aims to provide a type-safe, more intuitive and easy-to-use API. Vuex inspires it. However, a few crucial benefits make [Pinia the de facto Vuex 5](https://www.vuemastery.com/blog/advantages-of-pinia-vs-vuex/): These include:

- Great support for Typescript. This allows you to write type-safe code with code toolings such as autosuggestion and auto-completion.
- Pinia includes built-in support for automatically persisting the state of your application to storage, such as local storage or a server. This can be useful for building applications that can pick up where the user left off, even after the page has been refreshed or the user has closed the browser.
- Reduced boilerplate code that makes it very easier to learn. To modify the state of a store from a component using Vuex, you first perform an action, which then calls a mutation that changes the state. This ultimately means that each state change requires a large amount of boilerplate code and repetitive code. In Pinia, you can commit state changes directly inside your action and eliminate mutations.
- Pinia allows you to create different stores, which you can when using Vuex
- Pinia is exceptionally lightweight and smaller than Vuex. This may make it easier to use for applications of all levels.
- Rather than using the `dispatch` method or `MapAction` helper function, which is standard in Vuex, the store's actions are dispatched as regular function calls.
- Pinia has support for [Vue.js devtools](https://devtools.vuejs.org/).

### How Pinia Works

To understand how Pinia works, let’s discuss a basic example that will let you understand the official [de facto Vuex 5]((https://www.vuemastery.com/blog/advantages-of-pinia-vs-vuex/)). Below is a skeleton of a Pinia store:

```js
import { defineStore } from "pinia";

//define the store
export const useTodoStore = defineStore('TodoStore', {
    // todos state here
    state: () => (
        {
            todos: [],
        }
    ),

    //Todos getters go here
    getters: {
        Total: (state) => {
            return state.todos.length;
        }
    },

    //Todos actions go here
    actions: {

        addTodo(todo) {
            this.todos.push(todo)
        },
    },
})
```

Based on the above example, we are:

- Defining a `TodoStore`, with three properties: `state`, `getters`, and `actions`.
- `state` defines the state of the store. In this case, the store has a single piece of state data which is an array called `todos`.
- `getters` define any methods that can be used to retrieve data from the store. Here the `getter` `Total` returns the numbers of the todos saved in the state.
- `actions` defines methods needed to update the store's state. For example, the action `addTodo` pushes data to the todos array.

`useTodoStore` can be used to access the store's state, getters, and actions in a Vue component. Based on these properties:

- State refers to data that is shared between application components.
- Getters retrieve state data and return it when called by a component. However, getters can change the data in their own way without directly modifying or conflicting with the state data. A perfect example of a getter is a search, a total computation etc.
- Actions are mutations that can be used to modify the state data. This includes fetching, adding, updating or deleting state data.

### Setting up Vue.js with Pinia

Now that we understand Pinia at a basic level. Let’s now dive in and implement Pinia states in an actual Vue application. Note that Pinia has support for both Vue 2 and Vue 3. This guide uses Vue 3. We will create a basic Todos app demonstrating how to use and manage a Pinia store.

To [create a Vue 3 app](https://vuejs.org/guide/quick-start.html###creating-a-vue-application), run the following command:

```bash
npm init vue@latest
```

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/app.png)

Note: adding Pinia to your project using the above command prompts. However, if you have already created an existing project, you can run the following command to have Pinia installed:

```bash
npm install pinia
```

Change the directory to the newly created application:

```bash
cd Vue_Pinia_Todos_App
```

Run the following command to install the application dependencies:

```bash
npm install
```

This project is already configured with Pinia. However, if you installed Pinia using `npm install pinia`, you will be required to configure Pinia. Navigate to your `main.js` file and ensure you have the following changes:

```js
import { createPinia } from 'pinia'

const app = createApp(App)
app.use(createPinia())
app.mount('###app')
```

As a requirement, you wil require some CSS styling for this guide. [Copy this CSS code](https://github.com/kimkimani/Vue.js-Pinia-Todo-App/blob/main/src/assets/main.css) into your `src/assets/main.css` file.

### Creating a Pinia Store

We are creating a simple todo application. Using Pinia, let's create a store to manage the todos states data. In the `src` directory, create a `stores` folder if you don't have one. Inside this new folder, create a `TodoStore.js`. Here is how we’ll define the todos store properties:

- Import Pinia `defineStore` method:

```js
import { defineStore } from "pinia";
```

- Create and export a Vue.js store using the `defineStore` function from the Pinia library as follows:

```js
export const useTodoStore = defineStore('TodoStore', {

}
```

Inside he above created `useTodoStore`() function, add the Todos properties as follows:

- Create an empty array for storing the todos state data:

```js
state: () => (
    {
        todos: [],
    }
),
```

- Create the store actions:

```js
actions: {
    getTodos() {

    },
    addTodo(todo) {
        this.todos.push(todo)

    },
    deleteTodo(id) {
        this.todos = this.todos.filter((todo) => {
            return todo.id !== id
        })
    },
    toggleCompleted(id) {
        const todo = this.todos.find(todo => todo.id === id)
        todo.isDone = !todo.isDone
    }
},
```

`action` represents the mutations used to modify the state data. Here:

1. `getTodos()` - fetches the available todos in the store
2. `addTodo()` - adds new todos from the store.
3. `deleteTodo()` - deletes a todo from the store.
4. `toggleCompleted()` - updates the todos `isDone` value to true.


- Create the getters:

```js
getters: {
    CompletedTodos() {
        return this.todos.filter((t) => t.isDone)
    },
    TotalCompleted() {
        return this.todos.reduce((prev, curr) => {
            return curr.isDone ? prev + 1 : prev
        }, 0)
    },
    Total: (state) => {
        return state.todos.length;
    }
},
```

As explained earlier, `getters` change the component state without directly modifying or conflicting with the state data. In this example, we have the following getters:

1. `CompletedTodos()` - Each created todo will have an `isDone` value. `CompletedTodos()` will filter todos where the `isDone` value is true. It will create a state with a new array of completed todos.
2. `TotalCompleted()` - This counter will return all todos with the `isDone true` value.
3. `Total` - This counter will return all todos saves in the `todos` state data.

### Adding Data to the Store

We have created the Pinia store that we require. Let's now create the components to manage the states.

First, inside `src` create a `components` directory if you don't have one. Inside these `components` create a `TodoForm.vue`. This component will build a basic form for adding todos data to the store as follows:

```js
<script>
import { useTodoStore } from "../stores/TodoStore";
import { ref } from "vue";

export default {

  setup() {
    const todoStore = useTodoStore();
    const newTodo = ref("");

    function addItemAndClear() {
      
      if (newTodo.value.length > 0) {
        todoStore.addTodo({
          title: newTodo.value,
          id: Math.floor(Math.random() * 10000),
          isDone: false
        });

        newTodo.value = "";
      }
    }
    return { addItemAndClear, newTodo };
  },
};
</script>

<template>
  <form @submit.prevent="addItemAndClear">
    <input type="text" placeholder="Enter Todo" v-model="newTodo" />
    <button>New Todo</button>
  </form>
</template>
```

Here is what is happening:

- The `useTodoStore` that provides access to the todo store. `useTodoStore` is the global store that manages the state of the todo list.
- `newTodo` executes a `ref()` function to create a reactive reference to the todo form input and check whether its value is an empty string.

This is where it gets interesting. `addItemAndClear()` adds a new todo item to the `todoStore`. Using the `addTodo()` action we created earlier, Pinia will push a new entry to the store. Based on this example, each entry will have the following:

- A title from the form input,
- A randomly generated id number, and
- An `isDone` Boolean value set to false.

### Reading State Data from the Store

One Pinia adds a new entry to the store; we can read this data and display it as such. Let’s create a component to do so. Inside the `components` folder, create a `TodoDetails.vue` file as follows:

```js
<script>
import { useTodoStore } from "@/stores/TodoStore";

export default {
  props: ['todo'],
  setup() {
    // fetching the data
    const todoStore = useTodoStore();
    return { todoStore };
  }
}
</script>

<template>
  <div class="todo">
    <h3> {{ todo.title }}</h3>
    <div>
      <i @click="todoStore.deleteTodo(todo.id)">&###10060;</i>
      <i @click="todoStore.toggleCompleted(todo.id)" :class="{ active: todo.isDone }"> &###10004; </i>
    </div>
  </div>
</template>

<style scoped>
</style>
```

Here we are fetching the todos from a `TodoStore` and displaying them as such. In addition, we are updating the todo `isDone` value and deleting them from the store.

Let’s test what we have created so far. Navigate to the `src/App.vue` and execute the above components as follows:

```js
<script>
import { useTodoStore } from "@/stores/TodoStore";
import TodoDetails from "./components/TodoDetails.vue";
import TodoForm from "./components/TodoForm.vue";
import { storeToRefs } from "pinia";

export default {
  components: {
    TodoForm,
    TodoDetails,
  },

  setup() {
    // fetching the data
    const todoStore = useTodoStore();

    const { todos, CompletedTodos} = storeToRefs(todoStore)
    todoStore.getTodos()
 
    return { todoStore, todos, CompletedTodos};
  }
}
</script>

<template>
  <main>
      <header>
      <h1> Todos App </h1>
    </header>
    <div class="todos-form">
      <TodoForm />
    </div>
    <div class="todo-list">
      <div v-for="todo in todos" :key="todo.id">
        <TodoDetails :todo="todo" />
      </div>
    </div>
  </main>
</template>

<style scoped>
</style>
```

Run the application using the following command and open it on your browser:

```bash
npm run dev
```

Your application should be similar to:

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/app-running.png)

At this point, we want to inspect this appellation using Vue Devtool and understand what is happening when using Pinia. Go ahead and insect your application using Vue Devtool as follows:

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/pinia.png)

Using Vue Devtool, you can debug Pinia and inspect all the properties we define in the `TodoStore`.

If you add data to the store, you are able to inspect the states as follows:

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/piniastate.png)

### Managing Pinia Getters

As displayed in the Vue Devtool, we have the `CompletedTodos`, `TotalCompleted` and `Total` getters details saved by Pinia. Let’s render them so we can visually see what happens when the store values are updated on the component. Navigate to the `src/App.vue` and update the file as follows:

```js
<script>
import { useTodoStore } from "@/stores/TodoStore";
import TodoDetails from "./components/TodoDetails.vue";
import { ref } from "vue";
import TodoForm from "./components/TodoForm.vue";
import { storeToRefs } from "pinia";

export default {
  components: {
    TodoForm,
    TodoDetails,
  },

  setup() {

    const todoStore = useTodoStore();
    const { todos, CompletedTodos, Total, TotalCompleted } = storeToRefs(todoStore)
    todoStore.getTodos()
    const filter = ref('all');

    return { todoStore, filter, todos, CompletedTodos, Total, TotalCompleted };
  }
}
</script>

<template>
  <main>
    <header>
      <h1> Todos App </h1>
      <nav class="filter">
        <button @click="filter = 'all'"> Available Todos</button>
        <button @click="filter = 'done'"> Done Todos</button>
      </nav>
    </header>

    <div class="todos-form">
      <TodoForm />
    </div>

    <!-- all todos -->
    <div class="todo-list" v-if="filter === 'all'">
      <p>{{ Total }} Available Todos</p>
      <div v-for="todo in todos" :key="todo.id">
        <TodoDetails :todo="todo" />
      </div>
    </div>

    <!-- done todos -->
    <div class="todo-list" v-if="filter === 'done'">
      <p> {{ TotalCompleted }} Completed Todos </p>
      <div v-for="todo in CompletedTodos" :key="todo.id">
        <TodoDetails :todo="todo" />
      </div>
    </div>
  </main>
</template>

<style scoped>
</style>
```

The new application should look as follows:

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/getters.png)

Add new todos while clicking the check button to mark the complete todos as such.

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/available.png)

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/done.png)

This demonstrates how getter recreates their own states without interfering with the original states.

### How to Persist State with Pinia

You may have noted that the application so far does not persist the data on page reloads. Let’s see how we can persist Pinia stores between page loads.

Pinia includes built-in support for automatically persisting the state of your application to storage, such as local storage or a server. We will use an external library to get this done.

[Pinia-plugin-persistedstate](https://github.com/prazdevs/pinia-plugin-persistedstate) allows you to persist Pinia stores, which is compatible with everything that uses Pinia. To use it in our project, run the following command to install this library:

```bash
npm install pinia-plugin-persistedstate
```

To add the plugin to Pinia, navigate to the `src/main.js` file and ensure you have the following changes:

```js
import { createApp } from 'vue'
import App from './App.vue'
import {createPinia} from 'pinia'
import './assets/main.css'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

createApp(App)
.use(pinia)
.mount('###app')
```

Next, open `stores/TodoStore.js file` and the persist key below the `actions` property:

```js
persist: {
    storage: localStorage,
    key: 'todos-state',
},
```

This will persist the data on local storage and save the data using the key `todos-state`.

Rerun the application and add new data. Reload the page, and Pinia should now persist the added states. Any changes should persist in the local storage as follows:

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/persist.png)

### Resetting the State

Using Pina, you can reset the state data to its initial value. This can be done by calling the `$reset()` method on the TodoStore. Navigate to `src/App.vue` and add the following change on the header `nav` section:

```html
<header>
<h1> Todos App </h1>
<nav class="filter">
  <button @click="todoStore.$reset()">Reset Store</button>
  <button @click="filter = 'all'"> Available Todos</button>
  <button @click="filter = 'done'"> Done Todos</button>
</nav>
</header>
```

![Vue.js State Management using Pinia](/vuejs-state-management-using-pinia/reset.png)

Clicking the Reset Store button will reset the store to its initial value. This should also reset the states persisted by the local storage.

Now that you have mastered Vue.js State Management using Pinia consider diving deeper and learn JavaScript states for LocalStorage in this [How to use Local Storage using JavaScript](https://guruspedia.com/how-to-use-localstorage-using-javascript/) Definitive Guide.

### Conclusion

If you are looking for a simple, intuitive solution that is easy to learn and use, consider using Pinia for state management in your Vue.js application. I hope this guide has helped you understand Pinia in detail and what you can achieve with it. You can check the code used along this guide on this [GitHub repository](https://github.com/kimkimani/Vue.js-Pinia-Todo-App).