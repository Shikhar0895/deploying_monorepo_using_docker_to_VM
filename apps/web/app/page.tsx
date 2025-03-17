import { prismaClient } from "@repo/db/client";

export default async function Home() {
  const users = await prismaClient.users.findMany();

  return (
    <div className="p-12 flex flex-col justify-center">
      {JSON.stringify(users)}
    </div>
  );
}

// export const dynamic = "force-dynamic";
