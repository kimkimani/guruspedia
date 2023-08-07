---
layout: blog
status: publish
published: true
url: /creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/
title: Creating a Next.js Markdown Blog using MDX and TailwindCSS
description: Use Next.js with MDX to create Markdown-based blog content, style with Tailwind CSS, and display the content using Next.js. Then deploy the Next.js Markdown app online using Vercel.
date: 2023-08-06T11:17:16-04:00
topics: [Web, ReactJS, NextJS]
excerpt_separator: <!--more-->
images:
  - url: /creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/hero.jpg
    alt: Creating a Next.js Markdown Blog using MDX and TailwindCSS
---

[Next.js](https://nextjs.org/) is a server-rendered [React](https://reactjs.org/) framework. It allows you to create scalable and production-ready applications with ease. Next.js offers many features that make building large-scale production-ready React apps more straightforward. Some of the benefits that you get from using Next.js include the following:

-   Automatic code splitting for faster page loads
-   Server-side rendering for improved SEO and performance
-   Images and assets optimization
-   Easy deployment to a variety of hosting platforms

In this guide, you will use Next.js to build a blog app. You will MDX to create Markdown-based content, style with Tailwind CSS, and display the content using Next.js. You will finally deploy the Next.js Markdown app online using Vercel.
<!--more-->

### What is MDX?

To understand what [MDX](https://mdxjs.com/) is, let’s discuss [Markdown](https://www.markdownguide.org/). Markdown is a syntax that allows us to format text for a web page. It will enable you to write content using easy-to-read and easy-to-write syntax using text format. Markdown is popularly used to natively edit messages via WhatsApp and slack. It is also commonly used by Reddit, GitHub, and Stack Overflow to format content.

Markdown uses a simple syntax to format text. This includes headings, lists, links, and more. It is often used to format readme files, documentation, and other types of content on the web.

Here is an example of some basic Markdown syntax:

```markdown
# This is My Heading 1

## This is My Heading 2

- List item 1

- List item 2

[This is Link text Example](http://example.com)

This is *italic* text.

This is **bold** text.
```

When you render the Markdown code, it will be displayed on the web as follows:

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image1.png)

To display Markdown content on a webpage, you need a parser to validate HTML that the web can understand. This is where MDX comes in handy MDX is a format that allows you to run Markdown in JSX. It is a library for converting Markdown to HTML on the web.

This allows you to include React components in your Markdown content. This makes it possible to create interactive and dynamic content using Markdown.

Let’s dive in and create a Next.js app that uses Markdown syntax, then render the content to the web pages using Next.js.

### Prerequisites

To continue in this article, it is helpful to have the following:

- [Node.js](https://nodejs.org/en/) installed on your computer.
- Prior experience working with JavaScript.
- A GitHub account.
- Git or GitHub desktop installed on your computer.

### Creating the Next.js App

Open a terminal that points to the directory where you want to create a new Next.js app. Run the following command to create the app:

```bash
npx create-next-app mdx-app
```

This will bootstrap the application, create a new directory with the name of your app as mdx-app and install all the necessary dependencies.

- Proceed to the newly created directory:

```bash
cd mdx-app
```

Start the development server:

```bash
npm run dev
```

This will start the development server and open the app in your default browser. If not, you can access the application using the URL `http://localhost:3000/`.

The development server will automatically reload the app whenever you make changes to the code. This way, you can see your changes in real-time on the browser.

You now have a basic Next.js app running on your machine. Let’s start configuring the application to create the ideal application to execute Markdown.

### Installing MDX Dependencies

To use MDX with Next.js, you will require the following libraries.

- *path*:

For getting the directories from the file system.

- *fs*:

For reading directories and files. You will create files that contain
Markdown content. FS will be used to read these files from your file
system.

- *gray-matter*:

gray-matter is used for extracting front matter from files. Front matter is a block of metadata placed at the beginning of a Markdown file. This helps you to define metadata such as its title, author, and date for static site generators such as Next.js. For example:

```markdown
// Your file front matter

---

title: My Blog Post

author: John Doe

date: 2021-01-01

---

// Your Content

# This is My Heading 1

## This is My Heading 2

- List item 1

- List item 2

[This is Link text Example](http://example.com)
```

- *next-mdx-remote*:

Allows you to render MDX content. In this case, next-mdx-remote will parse the MDX content to generate it as a React component.

To install the above packages, run the following command:

```bash
yarn add fs gray-matter next-mdx-remote path
```

### Configuring TailwindCSS

[TailwindCSS](https://tailwindcss.com/) is a CSS utility framework that allows you to style your elements by applying classes to them. Instead of writing custom CSS styles, you can use the predefined classes provided by TailwindCSS to style your elements. To TailwindCSS in your project, run the following command:

```bash
yarn tailwindcss postcss autoprefixer
```
Run the following command to set up TailwindCSS in the project:

```bash
npx tailwind init -p
```

This will create a `tailwind.config.js` file. Edit the newly created `tailwind.config.js` as follows to map the files to be styled:

```js
module.exports = {
  content: [
    "./pages/**/*.{js,ts,tsx,jsx}",

    "./components/**/*.{js,ts,tsx,jsx}",
  ],

  theme: {
    extend: {},
  },

  plugins: [],
};
```

Import the tailwind files on the `styles/globals.css` files:

```bash
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### Adding Posts with MDX

Let’s now create MDX content that Next.js will use. In your project root folder, create a `posts` directory. Create a `making-chicken-stew.mdx` file in the `posts` directory. The name needs to be in hyphens since it will be the slug/link to access the post.

Edit the file as follows using gray-matter and Markdown syntax:

```markdown
---
date: '2021-03-28'

thumbnail: /assets/how-to-make-beef-stew.jpeg

title: How to make Beef stew

description: The soup stock from sea kelp and dried bonito flakes can be used in many Japanese food such as miso soup, soba, udon, and stew.

readTime: 4
---

### Ingredients

- 1000 ml water.
- 10 grams dried kelp.
- 40 grams bonito flakes.

<br />

### Directions

- Lightly wipe the surface of the kelp with a tightly wrung cloth.
- Put water and kelp in a pot.
- Heat on low heat, and when small bubbles come out from the bottom of the pot (about 7 minutes), remove the kelp.
- When the kelp soup stock boils, add bonito flakes and simmer on low heat for 1 minute.
- Set a colander on a bowl, spread a paper towel on it, and strain the soup stock.

You can check it out on [YouTube](https://youtu.be/6Lxdp1R40EY).

<br />

<h1> Preservation Method </h1>

Transfer the stock to a food storage container and store in the fridge. It can be used for 2-3 days.

<h1> Tips </h1>

- The white powder on the surface of dried kelp is "umami", so do not remove it.
```

Ensure you add the thumbnails to the `public/assets directory.` The thumbnails should be named based on the path added above. For example, `how-to-make-chicken-stew.jpeg`.

Feel free to add more data and create more files.

### Building Components

A component is a reusable code used to build a page's user interface. Next.js uses the React library to define and create components. They are then rendered to the browser as HTML. Let’s create a component that Next.js will use to generate all the `.md` that you create in your `posts` directory.

In the project's root folder, create a `components` folder. Inside the folder, create a `PostCard.js` file and edit it as follows:

```js
import React from "react";

export default function PostCard({ post }) {
  return (
    // A card to wrap all elements

    <div className="rounded-md w-71 transition-all hover:text-green-700 hover:shadow-sm hover-scale:100 cursor:pointer">
      // post thumbnail image
      <img
        className="h-40 w-64"
        src={post.frontMatter.thumbnail}
        alt="postCardImage"
      />
      <div className="mt-2 p-2">
        // post content
        <h2 className="font-semibold text-xl">{post.frontMatter.title}</h2>
        // post description
        <p className="mt-2">{post.frontMatter.description}</p>
      </div>
      <div className="flex flex-row space-x-4">
        // post date
        <h2 className="text-green-700"> 📅{post.frontMatter.date}</h2>
        // post readTime
        <p className="text-green-700">⏰{post.frontMatter.readTime} min read</p>
      </div>
    </div>
  );
}
```

The PostCard component will be the posts object. For every post, the thumbnail, title, and description will be rendered.

### Creating Next.js Page with MDX

To display the posts, navigate to pages/index.js:

- Import the necessary files:

```js
import fs from "fs";
import path from "path";
import matter from "gray-matter";
import Link from "next/link";
import Head from "next/head";
import Postcard from "../components/PostCard";
```

- Define getStaticProps for fetching the posts:

```js
export async function getStaticProps() {
  let files = fs.readdirSync(path.join("posts")); // get the files

  files = files.filter((file) => file.split(".")[1] == "mdx"); // filter only the mdx files

  const posts = files.map((file) => {
    // for each file extract the front matter and the slug

    const fileData = fs.readFileSync(path.join("posts", file), "utf-8");

    const { data } = matter(fileData);

    return {
      frontMatter: data,

      slug: file.split(".")[0],
    };
  });

  return {
    // export the posts

    props: {
      posts,
    },
  };
}
```

- Refine the render function as follows:

```js
export default function Home(props) {
  return (
    <div className="container w-[80%] mx-auto mt-10">
      <Head>
        <title>Cooking Blog</title>
      </Head>

      <h1 className="text-green-700 text-3xl font-bold my-12">Cooking Blog</h1>

      {props.posts.length > 0 ? (
        <div className="md:grid md:grid-cols-3 gap-8">
          {props.posts.map((post, index) => (
            <Link href={`/posts/${post.slug}`} key={index}>
              <Postcard post={post} />
            </Link>
          ))}
        </div>
      ) : (
        <h2 className="font-sans text-3xl">No posts yet</h2>
      )}
    </div>
  );
}
```

Ensure that the development is up and running:

```bash
yarn run dev
```

Open `http://localhost:3000/`, and all the posts you added will be rendered as follows:

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image4.png)

### Displaying a Single Post

The above component card displays the list of posts. However, a user also needs to access a single post's content. To do that, navigate to the `pages` folder, and create a `posts/[slug].js`. This will allow the user to access each post based on each post slug/name

Inside the created `pages/posts/[slug].js`:

- Import the necessary packages:

```js
import React from "react";
import fs from "fs";
import path from "path";
import matter from "gray-matter";
import Head from "next/head";
import { serialize } from "next-mdx-remote/serialize";
import { MDXRemote } from "next-mdx-remote";
```

- Define getStaticPaths to define a route for all posts:

```js
export async function getStaticPaths() {
  const files = fs.readdirSync(path.join("posts")); // get all posts

  const paths = files.map((file) => {
    // for all files extract the slug

    return {
      params: {
        slug: file.replace(".mdx", ""),
      },
    };
  });

  return {
    // export the paths

    paths,

    fallback: false,
  };
}
```

- Define getStaticProps to get data of the current post:

```js
export async function getStaticProps({ params: { slug } }) {
  const fileData = fs.readFileSync(path.join("posts", slug + ".mdx"), "utf-8"); // get the file data
  const { data, content } = matter(fileData); // extract the front matter and the content
  const mdxSource = await serialize(content); // serialize the content

  return {
    // export the data

    props: {
      frontMatter: data,

      slug,

      mdxSource,
    },
  };
}
```

- Render function:

```js
export default function Post(props) {
  return (
    <div className="container w-[80%] mx-auto mt-10">
      {props.frontMatter && props.mdxSource && (
        <div>
          <Head>
            <title>{props.frontMatter.title}</title>
          </Head>

          <h1 className="font-semibold my-8 text-xl text-green-700">
            {props.frontMatter.title}
          </h1>

          <MDXRemote {...props.mdxSource} />
        </div>
      )}
    </div>
  );
}
```

When you click on a single post, you should be able to access its content as such. Congratulations on Creating a Next.js Markdown Blog using MDX and TailwindCSS. Take your Next.js skills to new heights and learn [How to Test Next.js Applications with Jest](https://guruspedia.com/how-test-nextjs-apps-with-jest/) like a pro. You will love it.

### Deploying to Vercel

[Vercel](https://vercel.com/dashboard) s a cloud platform for hosting web applications, and it is a popular choice for deploying Next.js applications. Let’s deploy the Next.js we have created in the following steps.

Vercel allows for automatic deployments on every branch push and merges onto the Production Branch of your [GitHub](https://vercel.com/docs/concepts/git/vercel-for-github), [GitLab](https://vercel.com/docs/concepts/git/vercel-for-gitlab), and [Bitbucket](https://vercel.com/docs/concepts/git/vercel-for-bitbucket)projects. This way, Vercel ensures CI/CD. Every time a pull/merge request is made to deployed code, Vercel will create a unique deployment and ensure automatic deployments.

Here, we will use GitHub to push the application code. Vercel will then get the changes from the GitHub repository that host the application code.

You use either Git or GitHub desktop to push your code to GitHub. So at this point, ensure that the code is hosted in a GitHub repository. A sample [GitHub Repository](https://github.com/kimkimani/Nextjs_mdx_blog_app) contains the code we have just written.

On your Vercel account, navigate to [Vercel Dashboard](https://vercel.com/dashboard) and click Add new project as follows:

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image2.png)

Import Git Repository and select the GitHub repository you have just created and click Import, for example:

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image3.png)

Proceed and hit Deploy to allow Versel to pull code from the selected repository. Vercel will build, run checks and assign a domain to your deployment.

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image6.png)

Click **Continue to Dashboard**, and you should be able to access your deployment app on the listed Domain.

![Creating a Next.js Markdown Blog using MDX and TailwindCSS](/creating-nextjs-markdown-blog-using-mdx-and-tailwindcss/image5.png)

To update your Production Deployment, push changes to the GitHub repository `main` branch as such.

### Conclusion

This Guide taught you how to use Next.js to build a blog app. You used MDX to create Markdown-based content, style with Tailwind CSS, and display the content using Next.js. I hope this was helpful!